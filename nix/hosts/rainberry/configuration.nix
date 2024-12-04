{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  hypr.enable = true;
  hypr.ecoSystem = "gtk";

  tablet.enable = true;
  secureBoot.enable = true;
  yubikey.enable = true;
  impermanence.enable = true;

  fortinet.enable = true;
  gaming.enable = true;
  gpuType = "amd";

  hostname = "rainberry";
}
