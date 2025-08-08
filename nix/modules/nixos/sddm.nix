{ config, pkgs, lib, ... }:
let
  cfg = config.sddm;

in
{
  options = {
    sddm.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        SDDM display manager
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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
  };
}
