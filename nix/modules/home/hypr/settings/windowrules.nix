{ ... }:
let
  popupLandscape = "size <780 <520";
  popupPortrait = "size <520 <780";

in
{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float on, match:class ^(org.kde.*)$"
      "float on, match:class ^(org.gnome.*)$"
      "float on, match:class ^(org.remmina.*)$"
      "float on, match:class kdesystemsettings"
      "float on, match:class ^(org.freedesktop.impl.portal.desktop.*)$"
      "float on, match:class ^(xdg-desktop-portal.*)$"
      "float on, match:class mpv"
      "float on, match:class pavucontrol"
      "float on, match:class virt-manager"
      "float on, match:class nm-connection-editor"
      "float on, match:class kicad, match:title ^(.*KiCad.*)$"
      "float on, match:class nwg-look"
      "float on, match:class hyprland-share-picker"
      "float on, match:class org.gnome.NetworkDisplays"
      "float on, match:class naps2, match:title ^(?!NAPS2 -)(.*)$"
      "float on, match:class ^(org.fcitx.*)$"

      "float on, match:class org.mozilla.Thunderbird, match:initial_title ^$"
      "float on, match:class org.mozilla.Thunderbird, match:initial_title ^Write.*$"

      "float on, match:initial_title MainPicker"

      "${popupLandscape}, match:class org.kde.dolphin"
      "${popupLandscape}, match:class ^(xdg-desktop-portal-*)$"
    ];
  };
}
