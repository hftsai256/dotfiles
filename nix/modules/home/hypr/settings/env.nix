{ config, pkgs, lib, ... }:
let
  cfg = config.hypr;

  theme = {
    gtk = {
      gtk = "vimix-light-doder";
      icon = "Vimix-Doder";
    };

    kde = {
      gtk = "Breeze";
      icon = "breeze";
    };
  };

in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      simp1e-cursors
    ] ++ lib.optionals (cfg.ecoSystem == "gtk") [
      vimix-gtk-themes
      vimix-icon-theme
    ] ++ lib.optionals (cfg.ecoSystem == "kde") [
      kdePackages.breeze-gtk
      kdePackages.breeze-icons
    ];

    xdg.configFile = {
      "uwsm/env".text = ''
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor

        export GDK_BACKEND=wayland
        export GTK_USE_PORTAL=1

        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export CLUTTER_BACKEND=wayland

        export MOZ_ENABLE_WAYLAND=1
        export MOZ_ACCELERATED=1
        export MOZ_WEBRENDER=1

        export XCURSOR_SIZE=24
        export XCURSOR_THEME=Simp1e-Breeze
      '';

      "uwsm/env-hyprland".text = ''
        export XDG_MENU_PREFIX=plasma-
        export XDG_CURRENT_DESKTOP=Hyprland
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=Hyprland
        export TERM=${config.term.app}
      '';
    };

    wayland.windowManager.hyprland.systemd.variables = [
      "DISPLAY"
      "HYPRLAND_INSTANCE_SIGNATURE"
      "WAYLAND_DISPLAY"
      "XDG_CURRENT_DESKTOP"
      "QT_QPA_PLATFORM"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION"
      "QT_AUTO_SCREEN_SCALE_FACTOR"
      "QT_SCALE_FACTOR_ROUNDING_POLICY"
      "GDK_BACKEND"
      "GTK_USE_PORTAL"
      "XCURSOR_SIZE"
      "XCURSOR_THEME"
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Source Sans Pro 10, Source Han Sans 9";
        monospace-font-name = "Fira Code 10, Symbols Nerd Font 9";
        font-antialiasing = "rgba";
        gtk-theme = theme.${cfg.ecoSystem}.gtk;
        icon-theme = theme.${cfg.ecoSystem}.icon;
      };
    };
  };
}
