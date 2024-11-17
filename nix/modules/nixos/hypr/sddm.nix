{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects
    sddm-sugar-dark
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    theme = "sugar-dark";
  };
}
