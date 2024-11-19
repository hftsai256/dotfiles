{ config, pkgs, lib, lanzaboote, ... }:
{
  options = {
    secureBoot.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  imports = [ lanzaboote.nixosModules.lanzaboote ];

  config = lib.mkIf config.secureBoot.enable {

    boot = {
      initrd.systemd.enable = true;
      bootspec.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };

    environment.systemPackages = with pkgs; [
      sbctl
      e2fsprogs
    ];
  };
}
