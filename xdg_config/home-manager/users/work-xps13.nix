{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Halley Tsai";
    userEmail = "htsai@cytonome.com";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../modules/home.nix
    ../modules/nix.nix
    ../modules/fonts
    ../modules/nvim
    ../modules/zsh
  ];

  home.packages = [];
}

