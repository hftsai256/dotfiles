{ config, pkgs, lib, ... }:
let
  cfg = config.hypr;

in
{
  config = lib.mkIf (cfg.enable && cfg.ecoSystem == "gtk") {
    environment.systemPackages = with pkgs; [
      polkit
      polkit_gnome
      gnome-keyring

      nautilus
      nautilus-python
      ghex
      file-roller
      gnome-calculator
      gnome-font-viewer
      gnome-characters
      gnome-disk-utility
      gnome-bluetooth
      gnome-control-center
      gnome-nettool
      gnome-connections

      evince
      loupe
      gedit
      baobab

      gsettings-desktop-schemas

      adwaita-qt
      adwaita-qt6
    ];

    qt.platformTheme = "qt5ct";

    security = {
      polkit.enable = true;
      pam.services.login.enableGnomeKeyring = true;
    };

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "hyprland" "gtk" ];
        };
      };
    };

    programs.seahorse.enable = true;
    programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    services.gnome.gnome-keyring.enable = true;

    services.gvfs.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "The Gnome's Implementation of Policy Kit Authentication Agent";
      wantedBy = [ "hyprland-session.target" ];
      wants = [ "hyprland-session.target" ];
      after = [ "hyprland-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
