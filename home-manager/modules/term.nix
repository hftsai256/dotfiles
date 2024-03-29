{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) glSource;
  term = {
    name = "kitty";
    font.name = "monospace";
    font.size = 9;
    opacity = "0.9";
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
    theme = "Hybrid";

    settings = {
      background_opacity = term.opacity;
    };
  };

  programs.alacritty = {
    enable = if term.name == "alacritty" then true else false;
    package = alacritty-pkg."${glSource}";
  };

  programs.foot = {
    enable = if term.name == "foot" then true else false;
    package = foot-pkg."${glSource}";
  };
}
