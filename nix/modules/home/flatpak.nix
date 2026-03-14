{ config, lib, pkgs, ... }:
{
  options = {
    flatpakTheming.enable = lib.mkEnableOption "Tweaks for applying flatpak themes";
  };

  config = lib.mkIf config.flatpakTheming.enable {
    home.activation.flatpakOverrides = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.flatpak}/bin/flatpak override --user \
        --filesystem=xdg-data/icons:ro \
        --filesystem=xdg-data/themes:ro \
        --filesystem=xdg-config/gtk-3.0:ro \
        --filesystem=xdg-config/gtk-4.0:ro \
        --filesystem=/nix/store:ro
    '';

    systemd.user.services.flatpak-fontconfig-sync = {
      Unit.Description = "Sync fontconfig to Flatpak apps";
      Service = {
        Type = "oneshot";
        ExecStart = "${config.home.homeDirectory}/.local/bin/flatpak-fontconfig-sync";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.user.paths.flatpak-fontconfig-sync = {
      Unit.Description = "Watch for new Flatpak app installs";
      Path = {
        PathChanged = "%h/.local/share/flatpak/app";
        Unit = "flatpak-fontconfig-sync.service";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
