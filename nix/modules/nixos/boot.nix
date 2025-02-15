{ config, pkgs, lib, ... }:
{
  options = {
    kernel.type = lib.options.mkOption {
      type = lib.types.enum [ "lts" "mainline" "rt" ];
      default = "lts";
      description = "Linux kernel variants";
    };
  };

  config.boot = let
    kernel = with pkgs; {
      lts = linuxPackages_6_12;
      mainline = linuxPackages_latest;
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
