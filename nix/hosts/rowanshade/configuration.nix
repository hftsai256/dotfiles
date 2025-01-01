{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hypr.enable = true;
  hypr.ecoSystem = "gtk";

  thunderbolt.enable = true;
  yubikey.enable = true;
  tablet.enable = true;
  secureBoot.enable = true;
  impermanence.enable = true;

  fortinet.enable = true;
  gaming.enable = false;
  gpuType = "intel";

  hostname = "rowanshade";
}
