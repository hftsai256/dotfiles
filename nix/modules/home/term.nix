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
          font = "monospace:size=${(toString config.term.fontsize)}";
          dpi-aware = "no";
        };

        colors = {
          alpha = config.term.opacity;
          foreground = "b7bcb9";
          background = "161718";

          regular0 = "1d1e21";
          regular1 = "8c2d32";
          regular2 = "788331";
          regular3 = "e5894f";
          regular4 = "4b6b88";
          regular5 = "6e4f79";
          regular6 = "4d7b73";
          regular7 = "5a6169";

          bright0 = "2a2e33";
          bright1 = "b74d50";
          bright2 = "b3be5a";
          bright3 = "e3b55e";
          bright4 = "6d90b0";
          bright5 = "a07eab";
          bright6 = "7fbeb3";
          bright7 = "b5b8b6";
        };
      };
    };
  };
}
