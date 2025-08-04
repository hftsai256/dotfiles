{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    ./hardware-configuration.nix
  ];

  gpu.type = "amd";
  gaming.enable = true;

  greetd.enable = true;

  hypr = {
    enable = true;
    ecoSystem = "gtk";
  };

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  logitech.enable = true;
  impermanence.enable = true;
  mfp.enable = true;

  fortinet.enable = true;

  virtualization = {
    enable = true;
    cpuType = "amd";
    lookingGlass = false;
  };

  hydra.enable = true;

  hostname = "rainberry";
}
