{ config, pkgs, lib, lanzaboote, ... }:
{
  options = {
    secureBoot.enable = lib.options.mkEnableOption "Secure boot (supported by lanzaboote)";
  };

  imports = [ lanzaboote.nixosModules.lanzaboote ];

  config = lib.mkIf config.secureBoot.enable {

    boot = {
      initrd.systemd.enable = true;
      bootspec.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };

    environment.systemPackages = with pkgs; [
      sbctl
      e2fsprogs
    ];
  };
}
