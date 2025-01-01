{ config, pkgs, lib, ... }:
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

        nwg-look

        hypridle
        hyprlock
        hyprcursor
        hyprpaper
        kanshi
        waybar
        mako
        wofi

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

    programs.hyprland.enable = true;

    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        comment = "Hyprland session managed by uwsm";
        prettyName = "Hyprland";
      };
    };
  };
}
