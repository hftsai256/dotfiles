{ lib, ... }:
let
  restartProgram = exec: args:
    "pgrep ${exec} && pkill ${exec}; exec ${exec}${lib.optionalString (args != "") " ${args}"}";

  restartService = unit:
    "systemctl --user restart ${unit}.service";

in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "wl-paste --watch cliphist store"
      (restartProgram "solaar" "--window=hide")
      (restartProgram "waybar" "")
      (restartService "hyprsunset")
    ];
  };
}
