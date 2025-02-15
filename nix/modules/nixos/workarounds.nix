# HACK: temporary workaround for flatpak
{ config, pkgs, lib, ...}:
let
  cfg = config.workarounds;


in {
  options = {
    workarounds.flatpak.enable = lib.mkEnableOption "flatpak workaround";
  };

  config = lib.mkIf cfg.flatpak.enable {
    system.fsPackages = [ pkgs.bindfs ];

    fileSystems =
    let
      mkRoBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };

      aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = builtins.attrValues {
          inherit (pkgs)
            simp1e-cursors
            noto-fonts
            noto-fonts-emoji
            source-sans-pro
            source-serif-pro
            source-han-sans;

          inherit (pkgs.kdePackages)
            breeze-gtk
            breeze-icons;
        };

        pathsToLink = [
          "/share/fonts"
          "/share/icons"
          "/share/themes"
        ];
      };

    in {
      "/usr/share/icons" = mkRoBind "${aggregated}/share/icons";
      "/usr/share/fonts" = mkRoBind "${aggregated}/share/fonts";
      "/usr/share/themes" = mkRoBind "${aggregated}/share/themes";
    };
  };
}

