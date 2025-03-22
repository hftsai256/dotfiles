{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
  ];

  hydra.enable = true;

  gpu.type = "intel";

  ipu6 = {
    enable = false;
    platform = "ipu6ep";
  };

  hypr.enable = true;
  hypr.ecoSystem = "kde";

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  logitech.enable = true;
  thunderbolt.enable = true;
  impermanence.enable = true;
  mfp.enable = true;

  fortinet.enable = true;
  gaming.enable = false;
  workarounds.flatpak.enable = true;

  hostname = "whiteforest";
}
