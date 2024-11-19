{ config, pkgs, lib, ... }:
{
  config = lib.mkIf (config.hypr.ecoSystem == "kde") {
    environment.systemPackages = with pkgs.kdePackages; [
      frameworkintegration # provides Qt plugin
      kauth # provides helper service
      kcoreaddons # provides extra mime type info
      kded # provides helper service
      kfilemetadata # provides Qt plugins
      kguiaddons # provides geo URL handlers
      kiconthemes # provides Qt plugins
      kimageformats # provides Qt plugins
      kio # provides helper service + a bunch of other stuff
      kio-admin # managing files as admin
      kio-extras # stuff for MTP, AFC, etc
      kio-extras-kf5
      kio-fuse # fuse interface for KIO
      kpackage # provides kpackagetool tool
      kservice # provides kbuildsycoca6 tool

      pkgs.polkit
      polkit-kde-agent-1
      kwallet
      kwallet-pam # kwallet PAM module
      kwalletmanager # provides KCMs and stuff

      breeze
      breeze-icons
      breeze-gtk
      ocean-sound-theme
      qqc2-breeze-style
      qqc2-desktop-style

      dolphin
      filelight
      kate
      ark
      okular
      gwenview
    ];

    security = {
      polkit.enable = true;
      pam.services.login.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
    };

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-kde ];
      config = {
        common = {
          default = [ "hyprland" "kde" ];
          "org.freedesktop.impl.portal.Lockdown" = "gtk";
          "org.freedesktop.impl.portal.Settings" = "gtk";
        };
      };
    };

    systemd.user.services.polkit-kde-authentication-agent-1 = {
      enable = true;
      description = "The KDE's Implementation of Policy Kit Authentication Agent";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
