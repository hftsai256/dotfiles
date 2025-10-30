{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.dell-xps-13-9315
    ./hardware-configuration.nix
  ];

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  services.intune.enable = true;

  gpu.type = "intel";

  ipu6 = {
    enable = false;
    platform = "ipu6ep";
  };

  greetd.enable = true;

  screencast.enable = true;

  hypr = {
    enable = true;
    ecoSystem = "gtk";
  };

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
