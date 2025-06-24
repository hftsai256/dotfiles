{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
  ];

  gpu.type = "intel";

  ipu6 = {
    enable = false;
    platform = "ipu6ep";
  };

  niri.enable = true;

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  logitech.enable = true;
  thunderbolt.enable = true;
  impermanence.enable = true;
  mfp.enable = true;

  fortinet.enable = true;
  gaming.enable = false;

  hydra.enable = true;

  hostname = "whiteforest";
}
