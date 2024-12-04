{ config, pkgs, lib, ... }:
{
  options = {
    yubikey.enable = lib.options.mkEnableOption "Yubikey support";
  };

  config = {
    hardware.gpgSmartcards.enable = config.yubikey.enable;

    environment.systemPackages = lib.optionals config.yubikey.enable (with pkgs; [
      yubikey-personalization
      yubikey-personalization-gui
      yubikey-manager
      yubikey-manager-qt
    ]);

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services = lib.mkIf config.yubikey.enable {
      pcscd.enable = true;
      udev.packages = [
        pkgs.yubikey-personalization
      ];
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      extraConfig = ''
        DefaultTimeoutStopSec=10s
      '';
    };
  };
}
