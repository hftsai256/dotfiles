{ config, pkgs, lib, hyprland-pkgs, ... }:
{
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
        plasma5Packages.qt5.qtwayland
        plasma5Packages.qt5.qtsvg

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
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      # package = hyprland-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage = hyprland-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    programs.hyprlock = {
      enable = true;
      #package = hyprland-pkgs.${pkgs.stdenv.hostPlatform.system}.hyprlock;
    };

  };
}
