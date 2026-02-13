{ config, pkgs, lib, hyprland, ... }:
let
  cfg = config.hypr;

in {
  imports = [
    ./kde-ecosystem.nix
    ./gtk-ecosystem.nix
  ];

  options = {
    hypr.enable = lib.mkEnableOption "Hyprland compositor";

    hypr.lowSpec = lib.mkEnableOption ''
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
    environment = {
      systemPackages = with pkgs; [
        kdePackages.qtwayland
        kdePackages.qtsvg

        networkmanagerapplet
        pavucontrol
        brightnessctl

        wl-clipboard
        cliphist
        grim
        slurp
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = 1;
      } // lib.optionalAttrs config.hypr.lowSpec {
        AQ_NO_MODIFIERS = 1;
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    programs.hyprland = {
      enable = true;
      # package = hyprland.pkgs.hyprland;
      # portalPackage = hyprland.pkgs.xdg-desktop-portal-hyprland;
    };

    programs.hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
    };

    security.pam.services.hyprlock = {
      enableGnomeKeyring = (cfg.ecoSystem == "gtk");
      enableKwallet = (cfg.ecoSystem == "kde");
    };

  };
}
