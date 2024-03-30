{ config, pkgs, specialArgs, ... }:
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
