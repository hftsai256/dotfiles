{ config, pkgs, lib, ... }:
{
  config = lib.mkIf (config.hypr.ecoSystem == "gtk") {
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

      gsettings-desktop-schemas
    ];

    security = {
      polkit.enable = true;
      pam.services.login.enableGnomeKeyring = true;
    };

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
      config = {
        common = {
          default = [ "hyprland" "gtk" ];
        };
      };
    };

    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;

    services.gvfs.enable = true;
  };
}
