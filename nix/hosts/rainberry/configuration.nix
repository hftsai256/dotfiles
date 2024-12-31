{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  gpuType = "amd";

  virtualization.enable = true;
  virtualization.cpuType = "amd";
  virtualization.lookingGlass = false;

  hypr.enable = true;
  hypr.ecoSystem = "gtk";

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  impermanence.enable = true;

  fortinet.enable = true;
  gaming.enable = true;

  hostname = "rainberry";
}
