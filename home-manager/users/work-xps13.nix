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
    ../modules/neovim.nix
    ../modules/term.nix
#    ../modules/rime.nix
    ../modules/fonts
    ../modules/zsh
  ];

  home.packages = with pkgs; [
  ];
}

