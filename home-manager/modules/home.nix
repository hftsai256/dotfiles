{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    btop
    broot
    yazi
    tree
  ];

  home.file = {
    ".local/bin" = {
      source = ../scripts;
      recursive = true;
    };
  };
}
