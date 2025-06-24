{ nixos-hardware, pkgs, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    ./hardware-configuration.nix
  ];

  gpu.type = "amd";

  virtualization.enable = true;
  virtualization.cpuType = "amd";
  virtualization.lookingGlass = false;

  niri.enable = true;

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  logitech.enable = true;
  impermanence.enable = true;
  mfp.enable = true;

  fortinet.enable = true;
  gaming.enable = false;

  hydra.enable = true;

  hostname = "rainberry";
}
