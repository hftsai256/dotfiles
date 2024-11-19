{ ... }:
let
  popupLandscape = "size <780 <520";
  popupPortrait = "size <520 <780";

in
{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float, class:^(org.kde.*)$"
      "float, class:^(org.gnome.*)$"
      "float, class:^(org.remmina.*)$"
      "float, class:kdesystemsettings"
      "float, class:^(org.freedesktop.impl.portal.desktop.*)$"
      "float, class:^(xdg-desktop-portal.*)$"
      "float, class:mpv"
      "float, class:.blueman-manager-wrapped"
      "float, class:pavucontrol"
      "float, class:virt-manager"
      "float, class:nm-connection-editor"
      "float, class:kicad,title:^(.*KiCad.*)$"
      "float, class:nwg-look"
      "float, class:hyprland-share-picker"
      "float, class:org.gnome.NetworkDisplays"
      "float, class:naps2,title:^(?!NAPS2 -)(.*)$"
      "float, class:^(org.fcitx.*)$"

      "float, class:org.mozilla.Thunderbird, initialTitle:^$"
      "float, class:org.mozilla.Thunderbird, initialTitle:^Write.*$"

      "${popupLandscape}, class:org.kde.dolphin"
      "${popupLandscape}, class:^(xdg-desktop-portal-*)$"
    ];
  };
}
