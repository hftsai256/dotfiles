{ nixos-hardware, pkgs, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    ./hardware-configuration.nix
  ];

  gpu.type = "amd";

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
  gaming.enable = false;

  virtualization = {
    enable = true;
    cpuType = "amd";
    lookingGlass = false;
  };

  hydra.enable = true;

  hostname = "rainberry";
}
