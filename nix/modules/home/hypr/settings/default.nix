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
      blur.enabled = false;
      shadow.enabled = false;
      rounding = 8;
    };

    animations = {
      enabled = if config.hypr.lowSpec then false else true;
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
