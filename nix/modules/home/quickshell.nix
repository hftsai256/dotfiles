{ config, pkgs, lib, ... }:
let
  cfg = config.qs;
  themeCfg = config.themes;

  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  xdgRepoPath = "${homeDirectory}/.dotfiles/xdg_config";

  qtctFontConfig = {
    qt5ct = "-1,5,50,0,0,0,0,0";
    qt6ct = "-1,2,400,0,0,0,0,0,0,0,0,0,0,1";
  };

  qtctConfig = variant: ''
    [Appearance]
    color_scheme_path=${config.xdg.dataHome}/color-schemes/noctalia.colors
    custom_palette=true
    standard_dialogs=default
    icon_theme=Tela-blue-dark
    style=Fusion

    [Fonts]
    fixed="monospace,10,${qtctFontConfig.${variant}}"
    general="Sans Serif,10,${qtctFontConfig.${variant}}"
  '';

  linkShareDir = subdir: pkg: name: {
    "${subdir}/${name}" = {
      source = "${pkg}/share/${subdir}/${name}";
      recursive = true;
    };
  };

in
{
  options = {
    qs.enable = lib.mkEnableOption "Quickshell/Noctalia module";
    themes.enable = lib.mkEnableOption "Manage themes over home-manager";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      themes.enable = lib.mkDefault true;

      programs.noctalia-shell = {
        enable = true;
        plugins = {
          sources = [{
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }];

          states = lib.genAttrs [
            "clipper"
            "polkit-agent"
            "workspace-overview"
            "screen-shot-and-record"
          ] (_name: {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          });
        };
      };

      xdg.configFile."noctalia/settings.json".source =
        mkOutOfStoreSymlink "${xdgRepoPath}/noctalia-settings.json";
    })

    (lib.mkIf themeCfg.enable {
      gtk = {
        enable = true;

        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
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
          font-name = "Sans Serif 10";
          monospace-font-name = "monospace 10";
          font-antialiasing = "rgba";
          color-scheme = "prefer-dark";
        };
      };

      # Synlink theme files for flatpak applications
      xdg.dataFile = lib.mkMerge [
        (linkShareDir "themes" config.gtk.theme.package config.gtk.theme.name)
      ];

      xdg.configFile = builtins.listToAttrs (map (variant: {
        name = "${variant}/${variant}.conf";
        value = { text = qtctConfig variant; };
      }) [ "qt6ct" "qt5ct" ]);

      home.pointerCursor = {
        name = "Simp1e-Breeze-Dark";
        package = pkgs.simp1e-cursors;
        size = 24;
      };

      home.packages = with pkgs; [
        nwg-look
        kdePackages.qt6ct
        libsForQt5.qt5ct
        adw-gtk3
        tela-icon-theme
        simp1e-cursors
      ];
    })

    { xdg.enable = true; }
  ];
}
