{ pkgs, ... }:
let
  user = "hftsai";

in
{
  imports = [
    ./hardware-configuration.nix
  ];

  hydra.enable = true;
  gpu.type = "amd";
  sddm.enable = false;
  kde.enable = false;
  mfp.enable = true;
  logitech.enable = true;

  hypr = {
    enable = true;
    ecoSystem = "kde";
  };

  jovian = {
    hardware.has.amd.gpu = true;

    steam = {
      inherit user;
      enable = true;
      autoStart = true;
      #desktopSession = "plasma";
      desktopSession = "hyprland-uwsm";
    };

    decky-loader = {
      inherit user;
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    steam-run
  ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  hardware.xone.enable = true;
  workarounds.flatpak.enable = true;

  hostname = "maplebright";
}
