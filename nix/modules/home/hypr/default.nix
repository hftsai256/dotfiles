{ config, pkgs, specialArgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  inherit (specialArgs) glSource;

  xdgPath = "${homeDirectory}/.dotfiles/xdg_config";

  hyprland-pkg = {
    native = pkgs.hyprland;
    nixgl = pkgs.null;
    null = pkgs.null;
    darwin = pkgs.null;
  };

in
{
  imports = [
    ./themes.nix
    ./settings
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland-pkg.${glSource};
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  services.hypridle.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde 
        xdg-desktop-portal-gtk
      ];
      config.hyprland.default = [ "hyprland" "kde" "gtk" ];
    };

    configFile = {
      "hypr/hyprlock.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprlock.conf";
      "hypr/hypridle.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hypridle.conf";
      "hypr/hyprpaper.conf".source = mkOutOfStoreSymlink "${xdgPath}/hypr/hyprpaper.conf";
      kanshi.source = mkOutOfStoreSymlink "${xdgPath}/kanshi";
      mako.source = mkOutOfStoreSymlink "${xdgPath}/mako";
      wofi.source = mkOutOfStoreSymlink "${xdgPath}/wofi";
      waybar.source = mkOutOfStoreSymlink "${xdgPath}/waybar";
    };
  };

}
