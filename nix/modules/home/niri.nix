{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";

  mirror = pkgs.writeShellScriptBin "mirror" ''
    set -euo pipefail

    DP_OUT=$(niri msg --json outputs | ${pkgs.jq}/bin/jq -r \
      '.[] | select(.name | test("^DP-")) | .name' | head -n1)

    if [ -n "$DP_OUT" ]; then
        echo "Mirroring eDP-1 to $DP_OUT"
        exec ${pkgs.wl-mirror}/bin/wl-present mirror eDP-1 \
          --fullscreen-output "$DP_OUT" --fullscreen
      else
        echo "No DP output connected" >&2
        exit 1
    fi
  '';

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
      mirror
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

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Source Sans Pro 10, Source Han Sans 9";
        monospace-font-name = "Fira Code 10, Symbols Nerd Font 9";
        font-antialiasing = "rgba";
        color-scheme = "prefer-dark";
      };
    };

  };

}
