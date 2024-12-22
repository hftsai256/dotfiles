{ config, ... }:
{
  imports = [
    ./keybinds.nix
    ./windowrules.nix
    ./monitors.nix
    ./env.nix
    ./init.nix
  ];

  wayland.windowManager.hyprland.settings = {
    debug.disable_logs = false;

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      natural_scroll = true;
      sensitivity = 0;

      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.5;
      };
    };

    general = {
      gaps_in = 4;
      gaps_out = "0, 8, 8, 8"; # CSS style: top right bottom left
      border_size = 2;
      "col.active_border" = "0x89b4faff";
      "col.inactive_border" = "0xff45475a";
      layout = "dwindle";
      allow_tearing = true;
    };

    decoration = {
      blur.enabled = !config.hypr.lowSpec;
      shadow.enabled = !config.hypr.lowSpec;
      shadow.color = "0xaa1d1f21";
      shadow.offset = "2, 1";
      rounding = 8;
    };

    animations = {
      enabled = !config.hypr.lowSpec;
      animation = [
        "windows, 1, 6, default, popin 80%"
        "border, 1, 6, default"
        "fade, 1, 6, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      vfr = true;
    };
  };
}
