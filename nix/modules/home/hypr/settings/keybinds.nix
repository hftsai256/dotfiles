{ config, ... }:
let
  cfg = config.hypr;

  fm = {
    gtk = "nautilus";
    kde = "dolphin";
  };

in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER+CTRL, t, exec, ${config.term.app}"
      "SUPER+CTRL, e, exec, ${fm.${cfg.ecoSystem}} $HOME"
      "SUPER+CTRL, b, exec, brave --password-store=detect"
      "SUPER+CTRL, m, exec, thunderbird"

      "SUPER+SHIFT, v, exec, cliphist list | wofi -S dmenu | cliphist decode | wl-copy"
      "SUPER, space, exec, wofi -S drun -m fuzzy -i --width 320"

      "SUPER, q, killactive"
      "SUPER+CTRL+SHIFT, 3, exec, grim"
      ''SUPER+CTRL+SHIFT, 4, exec, grim -g "$(slurp)"''

      "SUPER+CTRL, backspace, exec, $HOME/.config/waybar/scripts/power"

      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"
      "SUPER, h, movefocus, l"
      "SUPER, l, movefocus, r"
      "SUPER, k, movefocus, u"
      "SUPER, j, movefocus, d"

      "SUPER+SHIFT, up, movecurrentworkspacetomonitor, u"
      "SUPER+SHIFT, down, movecurrentworkspacetomonitor, d"
      "SUPER+SHIFT, left, movecurrentworkspacetomonitor, l"
      "SUPER+SHIFT, right, movecurrentworkspacetomonitor, r"
      "SUPER+SHIFT, k, movecurrentworkspacetomonitor, u"
      "SUPER+SHIFT, j, movecurrentworkspacetomonitor, d"
      "SUPER+SHIFT, h, movecurrentworkspacetomonitor, l"
      "SUPER+SHIFT, l, movecurrentworkspacetomonitor, r"

      # Move the currently focused window to the scratchpad
      "SUPER+SHIFT, minus, movetoworkspace, special"
      "SUPER+SHIFT, backspace, movetoworkspace, special"

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "SUPER+SHIFT, p, togglespecialworkspace"

      "SUPER, f, fullscreen, 1"

      # Toggle the current focus between tiling and floating mode
      "SUPER+SHIFT, return, movetoworkspace,e+0"
      "SUPER+SHIFT, return, togglefloating"
      "SUPER+SHIFT, return, centerwindow"
      "SUPER+SHIFT, space, pseudo"

      # Pulse Audio controls
      ",XF86AudioRaiseVolume, exec, pactl set-sink-volume 0 +5%" #increase sound volume
      ",XF86AudioLowerVolume, exec, pactl set-sink-volume 0 -5%" #decrease sound volume
      ",XF86AudioMute, exec, pactl set-sink-mute 0 toggle" # mute sound
      ",XF86AudioMicMute, exec, pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo toggle" # mute mic

      # Screen brightness controls
      ",XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
      ",XF86MonBrightnessDown, exec, brightnessctl -q s 10%\-"
    ] ++ (
      builtins.concatLists (builtins.genList (i:
        let ws = if i == 0 then 10 else i;
        in [
          "SUPER, ${toString i}, workspace, ${toString ws}"
          "SUPER+SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
        ]
      ) 10)
    );

    bindm = [
      # resize windows with mainMod + LMB/RMB and dragging
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
