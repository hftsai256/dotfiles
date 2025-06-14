{ config, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";

in
{
  imports = [
    ./kanshi.nix
    ./notifier.nix
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
      systemd.enable = false;
      package = null;
      portalPackage = null;
    };

    xdg = {
      configFile = {
        "hypr/hyprpaper.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprpaper.conf";
        "hypr/hypridle.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hypridle.conf";
        "hypr/hyprlock.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprlock.conf";
        wofi.source = mkOutOfStoreSymlink "${xdgPath}/wofi";
        waybar.source = mkOutOfStoreSymlink "${xdgPath}/waybar";
      };
    };

  };
}
