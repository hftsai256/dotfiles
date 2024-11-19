{ pkgs, ... }:
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

  gfx = "nixgl";
  term.app = "foot";

  imports = [
    ../modules/home/nixvim
    ../modules/home/term.nix
    ../modules/home/fonts
    ../modules/home/zsh
  ];

  home.packages = with pkgs; [
    xclip  # steamOS is still on X11
    mame-tools
  ];
}
