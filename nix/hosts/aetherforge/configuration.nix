{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  gpu.type = "intel";
  gaming = {
    enable = true;
    decky.enable = true;
  };

  greetd.enable = true;

  hypr = {
    enable = true;
    ecoSystem = "kde";
  };

  tablet.enable = true;
  secureBoot.enable = true;
  tpm2.enable = true;
  hid.wacom.enable = true;
  yubikey.enable = true;
  logitech.enable = true;
  thunderbolt.enable = true;
  impermanence.enable = true;
  mfp.enable = true;

  fortinet.enable = false;
  tftp.enable = false;

  hydra.enable = true;

  hostname = "aetherforge";
}

