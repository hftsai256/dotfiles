{ config, pkgs, lib, ... }:
{
  options = {
    fortinet.enable = lib.options.mkEnableOption
      "Fortinet VPN and related packages";

    tftp.enable = lib.options.mkEnableOption
      "TFTP server";
  };

  config =
  let
    vpnPkgs = with pkgs; [
      openfortivpn
      (callPackage ../../packages/openfortivpn-webview.nix {})
    ];

  in
  {
    environment.systemPackages = (with pkgs; [
      iw
    ]) ++ (lib.optionals config.fortinet.enable vpnPkgs);

    programs.nm-applet.enable = true;

    networking = {
      hostName = config.hostname;
      networkmanager.enable = true;
      nftables.enable = true;

      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 80 443 8080 ];
        allowedUDPPorts = lib.mkIf config.tftp.enable [ 69 ];
      };
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
        };
      };

      openssh.enable = true;

      samba.enable = true;
      samba.nmbd.enable = false;
      samba-wsdd.enable = true;

      atftpd.enable = config.tftp.enable;
    };
  };
}
