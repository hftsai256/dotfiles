{ config, pkgs, lib, ... }:
{
  options = {
    fortinet.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Fortinet VPN related packages
      '';
    };
  };

  config =
  let
    vpnPkgs = with pkgs; [
      openfortivpn
      (callPackage ../../packages/openfortivpn-webview.nix {})
    ];

    miracastPorts = {
      tcp = [ 7236 7250 ];
      udp = [ 7236 5353 ];
    };

  in
  {
    environment.systemPackages = (with pkgs; [
      iw
    ]) ++ (lib.optionals config.fortinet.enable vpnPkgs);

    networking = {
      hostName = config.hostname;
      networkmanager.enable = true;
      nftables.enable = true;

      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 80 443 8080 ] ++ miracastPorts.tcp;
        allowedUDPPorts = miracastPorts.udp;
        trustedInterfaces = [ "p2p-wl*" ];
      };
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      openssh.enable = true;

      samba.enable = true;
      samba-wsdd.enable = true;
    };
  };
}
