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
      layout = "dwindle";
      allow_tearing = true;

      "col.active_border" = "rgba(ffe3aaff)";
      "col.inactive_border" = "rgba(6d6483ff)";
    };

    decoration = {
      blur.enabled = !config.hypr.lowSpec;
      shadow.enabled = false;
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

    xwayland.force_zero_scaling = true;
    misc.vfr = true;
  };
}
