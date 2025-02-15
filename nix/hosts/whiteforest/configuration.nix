{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
  ];

  kernel.type = "mainline";

  ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hypr = {
    enable = true;
    ecoSystem = "kde";
  };

  thunderbolt.enable = true;
  yubikey.enable = true;
  tablet.enable = true;
  secureBoot.enable = true;
  impermanence.enable = true;

  fortinet.enable = true;
  gaming.enable = false;
  gpu.type = "intel";

  workarounds.flatpak.enable = true;

  hostname = "whiteforest";
}
