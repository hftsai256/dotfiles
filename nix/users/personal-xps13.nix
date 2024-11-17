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

  home.packages = with pkgs; [
    brave
    firefox
    thunderbird
    teams-for-linux
    mpv
    obs-studio
  ];

  imports = [
    ../modules/home/nixvim
    ../modules/home/term.nix
    ../modules/home/rime.nix
    ../modules/home/hypr
    ../modules/home/fonts
    ../modules/home/zsh
  ];
}
