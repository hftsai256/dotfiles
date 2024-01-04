{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.ripgrep
    pkgs.btop
    pkgs.broot
    pkgs.zoxide
    pkgs.eza
    pkgs.yazi
  ];

  home.file = { };
}
