{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) glSource;
  toString = pkgs.lib.strings.floatToString;

  term = {
    name = "kitty";
    font.name = "monospace";
    font.size = 9;
    opacity = 0.9;
  } // (if builtins.hasAttr "term" specialArgs
    then specialArgs.term else {}
  );

  kitty-pkg = {
    native = pkgs.kitty;
    nixgl = pkgs.kitty-nixgl;
    null = pkgs.null;
    darwin = pkgs.null;
  };

  alacritty-pkg = {
    native = pkgs.alacritty;
    nixgl = pkgs.alacritty-nixgl;
    null = pkgs.null;
    darwin = pkgs.null;
  };

  foot-pkg = {
    native = pkgs.foot;
    nixgl = pkgs.foot-nixgl;
    null = pkgs.null;
    darwin = pkgs.null;
  };

in {
  programs.kitty = {
    enable = if term.name == "kitty" then true else false;
    package = kitty-pkg."${glSource}";
    font.name = term.font.name;
    font.size = term.font.size;
    shellIntegration.enableZshIntegration = true;
    themeFile = "Hybrid";

    settings = {
      background_opacity = (toString term.opacity);
      selection_background = "#81a2be";
    };
  };

  programs.alacritty = {
    enable = if term.name == "alacritty" then true else false;
    package = alacritty-pkg."${glSource}";

    settings = {
      bell = {
        animation = "EaseOutExpo";
        color = "#ffffff";
        duration = 250;
      };

      font.size = term.font.size;
      font.normal.family = term.font.name;

      window.opacity = term.opacity;
    };
  };

  programs.foot = {
    enable = if term.name == "foot" then true else false;
    package = foot-pkg."${glSource}";

    settings = {
      main = {
        font = "${term.font.name}:${(toString term.font.size)}";
        dpi-aware = "yes";
      };

      colors = {
        alpha = term.opacity;
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
}
