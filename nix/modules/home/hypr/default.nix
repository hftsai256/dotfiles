{ config, pkgs, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";

in
{
  imports = [
    ./themes.nix
    ./kanshi.nix
    ./notifier.nix
    ./settings
  ];

  options = {
    hypr.lowSpec = lib.mkEnableOption ''
      Enable this option on HW limited/low spec machine to apply patches and
      reduce animation
    '';
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = if (config.gfx == "native") then pkgs.hyprland else pkgs.null;
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
