{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Halley Tsai";
    userEmail = "hftsai256@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../modules/home.nix
    ../modules/nix.nix
    ../modules/neovim.nix
    ../modules/fonts
    ../modules/zsh
  ];

  home.packages = with pkgs; [
    jq
  ];
}
