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
    services.udev.extraRules = ''
      ACTION=="move", SUBSYSTEM=="net", \
        ATTRS{idVendor}=="0b95", ATTRS{idProduct}=="1790", \
        TAG+="systemd", ENV{SYSTEMD_WANTS}="ax88179-init@%k.service"
    '';

    systemd.services."ax88179-init@" = {
      description = "Initialize AX88179B PHY on %I";
      bindsTo = [ "sys-subsystem-net-devices-%i.device" ];
      after = [ "sys-subsystem-net-devices-%i.device" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
        ExecStart = "${pkgs.ethtool}/bin/ethtool %I";
        RemainAfterExit = false;
      };
    };

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
