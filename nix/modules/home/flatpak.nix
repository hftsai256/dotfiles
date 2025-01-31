# HACK: temporary workaround for flatpak
{ config, pkgs, lib, ...}:
let
  cfg = config.workarounds.flatpak;

  aggregated = pkgs.buildEnv {
    name = "system-fonts-and-icons";
    paths = builtins.attrValues {
      inherit (pkgs)
        simp1e-cursors
        vimix-gtk-themes
        vimix-icon-theme
        noto-fonts
        noto-fonts-emoji
        source-sans-pro
        source-serif-pro
        source-han-sans;

      inherit (pkgs.kdePackages)
        breeze-gtk
        breeze-icons;
    };
  };

in {
  options = {
    workarounds.flatpak.enable = lib.mkEnableOption "flatpak workaround";
  };

  config = lib.mkIf cfg.enable {
    xdg.dataFile."icons" = {
      source = "${aggregated}/share/icons";
      recursive = true;
    };
    xdg.dataFile."fonts" = {
      source = "${aggregated}/share/fonts";
      recursive = true;
    };
    xdg.dataFile."themes" = {
      source = "${aggregated}/share/themes";
      recursive = true;
    };
  };
}
