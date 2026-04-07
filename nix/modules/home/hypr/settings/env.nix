{ config, ... }:
{
  wayland.windowManager.hyprland.settings.env = [
    "QT_QPA_PLATFORM,wayland"
    "QT_QPA_PLATFORMTHEME,qt6ct"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
    "QT_SCALE_FACTOR_ROUNDING_POLICY,RoundPreferFloor"

    "GDK_BACKEND,wayland"

    "GDK_SCALE,2"
    "GTK_USE_PORTAL,1"

    "SDL_VIDEODRIVER,wayland"
    "SDL_TOUCH_MOUSEID_HANDLING,1"
    "_JAVA_AWT_WM_NONREPARENTING,1"
    "CLUTTER_BACKEND,wayland"

    "MOZ_ENABLE_WAYLAND,1"
    "MOZ_ACCELERATED,1"
    "MOZ_WEBRENDER,1"

    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "TERM,${config.term.app}"
  ];
}
