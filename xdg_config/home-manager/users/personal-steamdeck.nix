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
    ../modules/fonts
    ../modules/nvim
    ../modules/zsh
  ];

  home.packages = with pkgs; [
    kitty
    xclip
  ];
}
