{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  gpu.type = "amd";
  gaming = {
    enable = true;
    console.enable = true;
    decky.enable = true;
  };

  greetd.enable = true;

  hypr.enable = true;
  hypr.ecoSystem = "gtk";

  tablet.enable = true;
  mfp.enable = true;
  logitech.enable = true;

  virtualization = {
    enable = true;
    cpuType = "amd";
    vfio.enable = true;
  };

  hydra.enable = true;

  hostname = "maplebright";
}
