{
  config,
  options,
  pkgs,
  lib,
  ...
}: let
  hasRoland = lib.hasAttrByPath ["services" "roland"] options;
in {
  config = lib.mkIf config.hypr.enable (
    lib.optionalAttrs hasRoland {
      home.packages = lib.mkIf config.services.roland.enable (with pkgs; [
        iio-hyprland
        wvkbd
      ]);

      services.roland.settings.gestures = lib.mkIf config.services.roland.enable [
        {
          num_fingers = 3;
          kind = "SwipeUp";
          min_duration = 400;
          min_distance = 30.0;
          action = ''hyprctl dispatch "hl.dsp.window.fullscreen()"'';
        }
        {
          num_fingers = 3;
          kind = "SwipeUp";
          min_duration = 50;
          min_distance = 100.0;
          action = ''hyprctl dispatch "hl.dsp.focus({ workspace = '+1' })"'';
        }
        {
          num_fingers = 3;
          kind = "SwipeDown";
          min_duration = 50;
          min_distance = 100.0;
          action = ''hyprctl dispatch "hl.dsp.focus({ workspace = '-1' })"'';
        }
      ];
    }
  );
}
