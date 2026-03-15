{ config, pkgs, lib, ... }:
let
  cfg = config.hypr;

in
{
  config = lib.mkIf (cfg.enable && cfg.ecoSystem == "gtk") {
    environment.systemPackages = with pkgs; [
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

    programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    services.gvfs.enable = true;
  };
}
