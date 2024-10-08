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

  imports = [
    ../modules/nixvim
    ../modules/term.nix
    ../modules/fonts
    ../modules/zsh
  ];

  home.packages = with pkgs; [
    xclip  # steamOS is still on X11
    mame-tools
  ];
}
