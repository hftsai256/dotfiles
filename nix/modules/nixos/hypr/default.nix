{ config, pkgs, ... }:
{
  imports = [
    ./kde-ecosystem.nix
    ./sddm.nix
  ];

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland

    libsForQt5.qt5.qtsvg
    kdePackages.qtsvg

    libsForQt5.qt5ct
    kdePackages.qt6ct
    nwg-look

    hyprlock
    hyprcursor
    hyprpaper
    dconf
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

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    dbus.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    system-config-printer.enable = true;
    libinput.enable = true;
  };

}
