{ config, lib, pkgs, ... }:
{
  options = {
    la.sigrok.enable = lib.options.mkEnableOption "Sigrok-based Logic Analyzer";
  };

  config = lib.mkIf config.la.sigrok.enable {
    programs.pulseview.enable = true;

    environment.systemPackages = with pkgs; [
      sigrok-cli
      sigrok-firmware-fx2lafw
    ];
  };
}
