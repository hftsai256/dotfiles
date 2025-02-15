{ ... }:
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
  kde.enable = true;

  hypr = {
    enable = false;
    ecoSystem = "kde";
  };

  mfp.enable = true;

  jovian = {
    hardware.has.amd.gpu = true;

    steam = {
      inherit user;
      enable = true;
      autoStart = true;
      desktopSession = "plasma";
      # desktopSession = "hyprland-uwsm";
    };

    decky-loader = {
      inherit user;
      enable = true;
    };
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  hardware.xone.enable = true;
  workarounds.flatpak.enable = true;

  hostname = "maplebright";
}
