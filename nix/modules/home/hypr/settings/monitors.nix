{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, preferred, 0x0, 1.5"
      "DP-2, preferred, auto, 1.6"
    ];

    exec = [
      ''grep closed /proc/acpi/button/lid/LID0/state && hyprctl keyword monitor "eDP-1,disable"''
    ];

    bindl = [
      '',switch:off:Lid Switch, execr, hyprctl keyword monitor "eDP-1,preferred,0x0,1.5"''
      '',switch:on:Lid Switch, execr, hyprctl keyword monitor "eDP-1,disable"''
    ];

    workspace = [
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1, default:true"
    ];
  };
}
