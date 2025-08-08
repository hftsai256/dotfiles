{ config, lib, ... }:
let
  cfg = config.hypr;

  restartProgram = exec: args:
    "pgrep ${exec} && pkill ${exec}; exec ${exec}${lib.optionalString (args != "") " ${args}"}";

in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      (restartProgram "noctalia-shell" "")
      (restartProgram "solaar" "--window=hide")
      "wl-paste --watch cliphist store"
    ] ++

    lib.optionals cfg.touchscreen.enable [
      (restartProgram "wvkbd-mobintl" "--hidden -L 240")
      (restartProgram "iio-hyprland" "")
    ];
  };
}
