{ config, lib, pkgs, ... }:
let
  cfg = config.hypr.touchscreen;
  shell = "noctalia-shell ipc call";

in {
  options = {
    hypr.touchscreen.enable = lib.mkEnableOption "touchscreen";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      iio-hyprland
      wvkbd
    ];

    wayland.windowManager.hyprland.plugins = with pkgs.hyprlandPlugins; [
      hyprgrass
    ];

    wayland.windowManager.hyprland.settings = {
      plugin = {
        touch_gestures = {
          sensitivity = 4.0;
          workspace_swipe_edge = "";

          hyprgrass-gesture = [
            "swipe, 3, vertical, workspace"
            "longpress, 3, up, fullscreen"
          ];

          # Hyprgrass is bugged:
          # - pinching in/out is reversed
          # - edge swipe left/right is reversed
          hyprgrass-bind = [
            ", edge:d:u, exec, pkill -SIGRTMIN wvkbd-mobintl"
            ", edge:l:r, movefocus l"
            ", edge:r:l, movefocus r"
            ", pinch:4:o, exec, ${shell} launcher toggle"
          ];

          hyprgrass-bindm = [
            ", longpress:2, movewindow"
          ];
        };
      };
    };
  };
}
