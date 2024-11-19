{ pkgs, ... }:
let
  restartProgram = exec:
    "pgrep ${exec} && pkill ${exec}; exec ${exec}"
  ;

in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "wl-paste --watch cliphist store"
      "hypridle"
    ];

    exec = [
      (restartProgram "hyprpaper")
      (restartProgram "mako")
      (restartProgram "waybar")
      (restartProgram "kanshi")
    ];
  };
}
