{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";
  userServices = [ "hypridle" "hyprpaper" "hyprsunset" ];

in
{
  imports = [
    ../kanshi.nix
    ../notifier.nix
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

    services = lib.genAttrs userServices
      (_: {
        enable = true;
      });

    systemd.user.services = lib.genAttrs
      userServices
      (_: {
        Unit = {
          After = lib.mkForce [ "hyprland-session.target" ];
          PartOf = lib.mkForce [ "hyprland-session.target" ];
        };
        Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
      });

    programs.hyprlock.enable = true;
    programs.fuzzel.enable = true;
    programs.waybar.enable = true;

    home.pointerCursor.hyprcursor.enable = true;

    xdg = {
      enable = true;
      configFile = {
        "hypr/hyprpaper.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprpaper.conf";
        "hypr/hypridle.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hypridle.conf";
        "hypr/hyprlock.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprlock.conf";
        "hypr/hyprsunset.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprsunset.conf";
        waybar.source = mkOutOfStoreSymlink "${xdgPath}/waybar-hypr";
      };
    };

  };
}
