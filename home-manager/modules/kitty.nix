{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) pkgsource;

  kitty-pkg = {
    native = pkgs.kitty;
    nixgl = pkgs.kitty-nixgl;
    null = pkgs.null;
    darwin = pkgs.null;
  };

in {
  programs.kitty = {
    enable = true;
    package = kitty-pkg."${pkgsource}";
    font.name = "monospace";
    font.size = 9;
    shellIntegration.enableZshIntegration = true;
    theme = "Hybrid";

    settings = {
      background_opacity = "0.90";
    };
  };
}
