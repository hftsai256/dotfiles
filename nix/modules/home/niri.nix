{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";

in {
  imports = [
    ./kanshi.nix
    ./notifier.nix
  ];

  options = {
    niri.enable = lib.options.mkEnableOption ''
      Niri desktop environment
    '';
  };

  config = lib.mkIf config.niri.enable {
    home.packages = with pkgs; [
      fuzzel
      waybar
      nautilus
      xwayland-satellite

      networkmanagerapplet
      pavucontrol
      brightnessctl

      wl-clipboard
      cliphist

      hypridle
      hyprlock
      swaybg

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

    xdg = {
      configFile = {
        niri.source = mkOutOfStoreSymlink "${xdgPath}/niri";
        "hypr/hypridle.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/niriidle.conf";
        "hypr/hyprlock.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprlock.conf";
        waybar.source = mkOutOfStoreSymlink "${xdgPath}/waybar-niri";
      };
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
      theme = {
        name = "Orchis-Dark-Compact";
        package = pkgs.orchis-theme;
      };
      cursorTheme = {
        name = "Simp1e-Breeze";
        package = pkgs.simp1e-cursors;
      };
    };

  };

}
