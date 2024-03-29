{ config, pkgs, specialArgs, ... }:
let
  term = (builtins.trace specialArgs specialArgs.term) // {
    font.size = 9.5;
  };

in
{
  programs.git = {
    enable = builtins.trace specialArgs true;
    userName = "Halley Tsai";
    userEmail = "hftsai256@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../modules/neovim.nix
    ../modules/term.nix
    ../modules/fonts
    ../modules/zsh
  ];

  home.packages = with pkgs; [
    xclip  # steamOS is still on X11
  ];
}
