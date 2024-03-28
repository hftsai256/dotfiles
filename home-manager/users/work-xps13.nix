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
    ../modules/nix.nix
    ../modules/neovim.nix
    ../modules/kitty.nix
#    ../modules/rime.nix
    ../modules/fonts
    ../modules/zsh
  ];

  home.packages = with pkgs; [
  ];
}

