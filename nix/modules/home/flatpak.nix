{ config, ... }:
let
  xdgConf = config.xdg.configHome;
  xdgData = config.xdg.dataHome;
  homeDir = config.home.homeDirectory;
  nixHmXdgData = "${homeDir}/.nix-profile/share";

  gtkTheme = config.gtk.theme.name;
  cursorTheme = config.home.pointerCursor.name;
  cursorSize = toString config.home.pointerCursor.size;

in
{
  home.file."${xdgData}/flatpak/overrides/global".text = ''
    [Context]
    filesystems=${homeDir}/.config:ro;${homeDir}/.local/share:ro;${homeDir}/.nix-profile/share:ro;${homeDir}/.local/state/nix/profiles:ro;/run/current-system/sw/share:ro;/nix/store:ro

    [Environment]
    GTK_THEME=${gtkTheme}
    XCURSOR_THEME=${cursorTheme}
    XCURSOR_SIZE=${cursorSize}
    XDG_DATA_DIRS=/app/share:/usr/share:/usr/share/runtime/share:/run/host/user-share:/run/host/share:/run/current-system/sw/share:${nixHmXdgData}:${xdgData}
    FONTCONFIG_PATH=${xdgConf}/fontconfig
  '';
}
