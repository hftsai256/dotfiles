{ config, pkgs, lib, ... }:
let
  cfg = config.hypr;

in
{
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;

      theme = {
        name = "Orchis-Dark-Compact";
        package = pkgs.orchis-theme;
      };

      iconTheme = {
        name = "Tela-blue-dark";
        package = pkgs.tela-icon-theme;
      };

      cursorTheme = {
        name = "Simp1e-Breeze-Dark";
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

    home.packages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      hyprqt6engine
    ];

    wayland.windowManager.hyprland.settings.env = [
      "QT_QPA_PLATFORMTHEME,hyprqt6engine"
      "QT_STYLE_OVERRIDE,kvantum"
      "KVANTUM_THEME,Orchis-solidDark"
      "KDE_COLOR_SCHEME,OrchisDark"
    ];

    xdg.dataFile = {
      "icons/Tela-blue-dark".source =
        "${pkgs.tela-icon-theme}/share/icons/Tela-blue-dark";

      "themes/Orchis-Dark-Compact".source =
        "${pkgs.orchis-theme}/share/themes/Orchis-Dark-Compact";

      "color-schemes/Orchis.colors".source =
        "${pkgs.orchis-kde}/share/color-schemes/Orchis.colors";

      "color-schemes/OrchisDark.colors".source =
        "${pkgs.orchis-kde}/share/color-schemes/OrchisDark.colors";
    };

    xdg.configFile = {
      "Kvantum/Orchis".source =
        "${pkgs.orchis-kde}/share/Kvantum/Orchis";

      "Kvantum/Orchis-solid".source =
        "${pkgs.orchis-kde}/share/Kvantum/Orchis-solid";

      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Orchis-solidDark
      '';

      "hypr/hyprqt6engine.conf".text = ''
        theme {
          color_scheme = ${pkgs.orchis-kde}/share/color-schemes/OrchisDark.colors
          icon_theme = Tela-blue-dark
          style = Orchis-solidDark
          font_fixed_size = 10
          font_size = 10
        }
      '';

      "kdeglobals".text = ''
        [General]
        widgetStyle=kvantum
        ColorScheme=OrchisDark
        fixed=Monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
        general=Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1


        [UiSettings]
        ColorScheme=OrchisDark

        [Icons]
        Theme=Tela-blue-dark

        [KDE]
        LookAndFeelPackage=com.github.vinceliuice.Orchis-dark-solid
      '';
    };

    home.pointerCursor = {
      name = "Simp1e-Breeze-Dark";
      package = pkgs.simp1e-cursors;
      size = 24;
    };
  };
}
