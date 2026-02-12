{ ... }:
let
  popupLandscape = "size <780 <520";
  popupPortrait = "size <520 <780";

in
{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float true, match:class ^(org.kde.*)$"
      "float true, match:class ^(org.gnome.*)$"
      "float true, match:class ^(org.remmina.*)$"
      "float true, match:class kdesystemsettings"
      "float true, match:class ^(org.freedesktop.impl.portal.desktop.*)$"
      "float true, match:class ^(xdg-desktop-portal.*)$"
      "float true, match:class mpv"
      "float true, match:class pavucontrol"
      "float true, match:class virt-manager"
      "float true, match:class nm-connection-editor"
      "float true, match:class kicad, match:title ^(.*KiCad.*)$"
      "float true, match:class nwg-look"
      "float true, match:class hyprland-share-picker"
      "float true, match:class org.gnome.NetworkDisplays"
      "float true, match:class naps2, match:title ^(?!NAPS2 -)(.*)$"
      "float true, match:class ^(org.fcitx.*)$"

      "float true, match:class org.mozilla.Thunderbird, match:initial_title ^$"
      "float true, match:class org.mozilla.Thunderbird, match:initial_title ^Write.*$"

      "float true, match:initial_title MainPicker"

      "${popupLandscape}, match:class org.kde.dolphin"
      "${popupLandscape}, match:class ^(xdg-desktop-portal-*)$"
    ];
  };
}
