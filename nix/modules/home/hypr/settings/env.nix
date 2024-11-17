{ ... }:
{
  home.sessionVariables = {
    AQ_NO_MODIFIERS = 1;
    XDG_MENU_PREFIX = "plasma-";

    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";

    MOZ_ENABLE_WAYLAND = 1;
    MOZ_ACCELERATED = 1;
    MOZ_WEBRENDER = 1;
  };
}
