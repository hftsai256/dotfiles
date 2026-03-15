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
        # Use Gnome Keyring anyways to same my life
        polkit
        polkit_gnome
        gnome-keyring

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

    programs.hyprland.enable = true;
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;

    security.polkit.enable = true;
    security.pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
      hyprlock.enableGnomeKeyring = true;
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "The Gnome's Implementation of Policy Kit Authentication Agent";
      wantedBy = [ "hyprland-session.target" ];
      wants = [ "hyprland-session.target" ];
      after = [ "hyprland-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

  };
}
