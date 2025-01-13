{ config, pkgs, lib, ... }:
{
  options = {
    sane.enable = lib.options.mkEnableOption "scanner module";
  };

  config = lib.mkIf config.sane.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "v4l" "escl" ];
    };

    services.printing.enable = true;
  };
}
