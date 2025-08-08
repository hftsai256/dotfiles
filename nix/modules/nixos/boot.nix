{ config, pkgs, lib, ... }:
let
  cfg = config.kernel;

in {
  options = {
    kernel.type = lib.options.mkOption {
      type = lib.types.enum [ "lts" "mainline" "rt" ];
      default = "mainline";
      description = "Linux kernel variants";
    };
  };

  config.boot = let
    kernel = with pkgs; {
      lts = linuxPackages_6_18;
      mainline = linuxPackages_latest;
      rt = linuxPackages-rt;
    };

  in {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = kernel.${cfg.type};

    supportedFilesystems = {
      btrfs = true;
      ntfs = true;
      zfs = lib.mkForce false;
    };
  };
}
