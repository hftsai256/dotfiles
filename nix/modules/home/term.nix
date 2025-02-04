{ config, pkgs, lib, ... }:
let
  toString = pkgs.lib.strings.floatToString;

  kitty-pkg = {
    native = pkgs.kitty;
    nixgl = pkgs.kitty-nixgl;
    null = pkgs.null;
  };

  alacritty-pkg = {
    native = pkgs.alacritty;
    nixgl = pkgs.alacritty-nixgl;
    null = pkgs.null;
  };

  foot-pkg = {
    native = pkgs.foot;
    nixgl = pkgs.foot-nixgl;
    null = pkgs.null;
  };

in {
  options = {
    term.app = lib.options.mkOption {
      type = lib.types.enum ["kitty" "alacritty" "foot"];
      default = "kitty";
      description = ''
        Terminal application. Supported options are:
          "kitty", "alacritty", "foot"
      '';
    };

    term.fontsize = lib.options.mkOption {
      type = lib.types.float;
      default = 9.0;
      description = ''
        Terminal font size
      '';
    };

    term.opacity = lib.options.mkOption {
      type = lib.types.float;
      default = 0.9;
      description = ''
        Terminal opacity
      '';
    };
  };

  config = {
    home.packages = [
      pkgs.xdg-terminal-exec
    ];

    programs.kitty = {
      enable = if config.term.app == "kitty" then true else false;
      package = kitty-pkg."${config.gfx}";
      font.name = "monospace";
      font.size = config.term.fontsize;
      shellIntegration.enableZshIntegration = true;
      themeFile = "Hybrid";

      settings = {
        background_opacity = (toString config.term.opacity);
        selection_background = "#81a2be";
      };
    };

    programs.alacritty = {
      enable = if config.term.app == "alacritty" then true else false;
      package = alacritty-pkg."${config.gfx}";

      settings = {
        bell = {
          animation = "EaseOutExpo";
          color = "#ffffff";
          duration = 250;
        };

        font.size = config.term.fontsize;
        font.normal.family = "monospace";

        window.opacity = config.term.opacity;
      };
    };

    programs.foot = {
      enable = if config.term.app == "foot" then true else false;
      package = foot-pkg."${config.gfx}";

      settings = {
        main = {
          font = "monospace:${(toString config.term.fontsize)}";
          dpi-aware = "no";
        };

        colors = {
          alpha = config.term.opacity;
          foreground = "c5c8c6";
          background = "1d1f21";

          regular0 = "282a2e";
          regular1 = "a54242";
          regular2 = "8c9440";
          regular3 = "de935f";
          regular4 = "5f819d";
          regular5 = "85678f";
          regular6 = "5e8d87";
          regular7 = "707880";

          bright0 = "373b41";
          bright1 = "cc6666";
          bright2 = "b5bd68";
          bright3 = "f0c674";
          bright4 = "81a2be";
          bright5 = "b294bb";
          bright6 = "8abeb7";
          bright7 = "c5c8c6";
        };
      };
    };
  };
}
