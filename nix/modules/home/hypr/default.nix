{ config, pkgs, lib, ... }:
{
  imports = [
    ../kanshi.nix
    ./settings
  ];

  options = {
    hypr.enable = lib.options.mkEnableOption ''
      Hyprland environment
    '';

    hypr.lowSpec = lib.options.mkEnableOption ''
      Enable this option on HW limited/low spec machine to apply patches and
      reduce animation
    '';

    hypr.ecoSystem = lib.mkOption {
      type = lib.types.enum [ "kde" "gtk" ];
      default = "gtk";
      description = ''
        Use either KDE or Gtk for system service backend
      '';
    };
  };

  config = lib.mkIf config.hypr.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
      package = null;
      portalPackage = null;
    };

    kanshi = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
}
