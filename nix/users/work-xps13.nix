{ ... }:
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

  gfx = "null";
  term.app = "foot";

  imports = [
    ../modules/home/nixvim
    ../modules/home/term.nix
    ../modules/home/fonts
    ../modules/home/zsh
  ];
}

