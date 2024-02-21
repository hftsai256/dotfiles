{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    btop
    broot
    zoxide
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
