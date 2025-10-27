{ pkgs, ... }:
let
  user = "hftsai";

in
{
  imports = [
    ./hardware-configuration.nix
  ];

  hydra.enable = true;

  virtualization = {
    enable = true;
    cpuType = "amd";
    vfio.enable = true;
  };

  gpu.type = "amd";

  mfp.enable = true;
  logitech.enable = true;

  hypr = {
    enable = true;
    ecoSystem = "gtk";
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

  hostname = "maplebright";
}
