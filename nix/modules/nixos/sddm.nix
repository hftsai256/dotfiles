{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    sddm-sugar-dark
  ];

  services.displayManager.defaultSession = lib.mkIf config.hypr.enable "hyprland-uwsm";

  services.displayManager.sddm = {
    enable = true;
    package = lib.mkForce pkgs.libsForQt5.sddm;
    wayland.enable = true;
    wayland.compositor = "kwin";
    theme = "sugar-dark";
    extraPackages = lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
  };
}
