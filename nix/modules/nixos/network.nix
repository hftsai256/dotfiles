{ config, pkgs, lib, ... }:
{
  options = {
    fortinet.enable = lib.options.mkEnableOption
        "Fortinet VPN and related packages";
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
      samba-wsdd.enable = true;
    };
  };
}
