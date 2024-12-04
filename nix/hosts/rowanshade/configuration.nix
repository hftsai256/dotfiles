{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  hypr.enable = true;
  hypr.ecoSystem = "gtk";

  thunderbolt.enable = true;
  tablet.enable = true;
  secureBoot.enable = true;
  impermanence.enable = true;

  fortinet.enable = true;
  gaming.enable = false;
  gpuType = "intel";

  hostname = "rowanshade";
}
