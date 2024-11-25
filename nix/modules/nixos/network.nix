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

  config = {
    environment.systemPackages = lib.mkIf config.fortinet.enable (with pkgs; [
      openfortivpn
      (callPackage ../../packages/openfortivpn-webview.nix {})
    ]);

    networking = {
      hostName = config.hostname;
      networkmanager.enable = true;
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
