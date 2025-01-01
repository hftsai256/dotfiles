{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec = [
      ''grep closed /proc/acpi/button/lid/LID0/state && kanshictl switch clamshell''
    ];

    bindl = [
      '',switch:off:Lid Switch, execr, kanshictl reload''
      '',switch:on:Lid Switch, execr, kanshictl switch clamshell''
    ];

    workspace = [
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1, default:true"
    ];
  };
}
