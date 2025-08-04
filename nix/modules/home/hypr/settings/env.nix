{ config, pkgs, lib, ... }:
let
  cfg = config.hypr;

  gtkTheme = {
    gtk = {
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
      theme = {
        name = "Orchis-Dark-Compact";
        package = pkgs.orchis-theme;
      };
    };

    kde = {
      theme = {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      };
      iconTheme = {
        name = "breeze";
        package = pkgs.kdePackages.breeze-icons;
      };
    };
  };

in
{
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;

      cursorTheme = {
        name = "Simp1e-Breeze-Dark";
        package = pkgs.simp1e-cursors;
      };

    } // gtkTheme.${cfg.ecoSystem};

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "breeze";
    };

    home.pointerCursor = {
      name = "Simp1e-Breeze-Dark";
      package = pkgs.simp1e-cursors;
      size = 24;
    };

    home.sessionVariables = {
      "QT_QPA_PLATFORM" = "wayland";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
      "QT_SCALE_FACTOR_ROUNDING_POLICY" = "RoundPreferFloor";

      "GDK_BACKEND" = "wayland";
      "GDK_SCALE" = "2";
      "GTK_USE_PORTAL" = "1";

      "SDL_VIDEODRIVER" = "wayland";
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "CLUTTER_BACKEND" = "wayland";

      "MOZ_ENABLE_WAYLAND" = "1";
      "MOZ_ACCELERATED" = "1";
      "MOZ_WEBRENDER" = "1";

      "XDG_MENU_PREFIX" = "plasma-";
      "XDG_CURRENT_DESKTOP" = "Hyprland";
      "XDG_SESSION_TYPE" = "wayland";
      "XDG_SESSION_DESKTOP" = "Hyprland";
      "TERM" = "${config.term.app}";
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
        color-scheme = "prefer-dark";
      };
    };
  };
}
