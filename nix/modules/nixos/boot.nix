{ config, pkgs, lib, ... }:
{
  options = {
    kernel.type = lib.mkOption {
      type = lib.types.enum [ "lts" "mainline" "rt" ];
      default = "lts";
      description = "Linux kernel variants";
    };
  };

  config.boot = let
    kernel = with pkgs; {
      lts = linuxPackages;
      mainline = linuxPackages_6_12;
      rt = linuxPackages-rt;
    };

  in {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = kernel.${config.kernel.type};
    supportedFilesystems = {
      btrfs = true;
      ntfs = true;
      zfs = lib.mkForce false;
    };
  };
}
