{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    simp1e-cursors
    tela-icon-theme
    orchis-theme
  ];
}
