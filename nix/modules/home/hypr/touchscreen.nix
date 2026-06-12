{ config, pkgs, lib, ... }:
{
  config = lib.mkIf (config ? services.roland
    && config.services.roland.enable
    && config.hypr.enable) {

    home.packages = with pkgs; [
      iio-hyprland
      wvkbd
    ];

    services.roland.settings.gestures = [
      { num_fingers = 3;
        kind = "SwipeUp";
        min_duration = 400;
        min_distance = 30.0;
        action = ''hyprctl dispatch "hl.dsp.window.fullscreen()"'';
      }
      { num_fingers = 3;
        kind = "SwipeUp";
        min_duration = 50;
        min_distance = 100.0;
        action = ''hyprctl dispatch "hl.dsp.focus({ workspace = '+1' })"'';
      }
      { num_fingers = 3;
        kind = "SwipeDown";
        min_duration = 50;
        min_distance = 100.0;
        action = ''hyprctl dispatch "hl.dsp.focus({ workspace = '-1' })"'';
      }
    ];
  };
}
