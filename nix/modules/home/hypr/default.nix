{ config, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

in {
  imports = [
    ../shikane.nix
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

    xdg.configFile = {
      "hypr/hyprland.lua".source =
        mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/hypr/hyprland.lua";
    };

    shikane.enable = true;
  };
}
