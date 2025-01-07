{ config, lib, pkgs, ... }:
{
  options = {
    la.sigrok.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Sigrok-based Logic Analyzer";
    };
  };

  config = lib.mkIf config.la.sigrok.enable {
    programs.pulseview.enable = true;

    environment.systemPackages = with pkgs; [
      sigrok-cli
      sigrok-firmware-fx2lafw
    ];
  };
}
