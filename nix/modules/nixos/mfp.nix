{ config, pkgs, lib, ... }:
{
  options = {
    mfp.enable = lib.options.mkEnableOption "scanner module";
  };

  config = lib.mkIf config.mfp.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "v4l" "escl" ];
    };

    services.printing.enable = true;
  };
}
