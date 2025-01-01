{ config, lib, ... }:
{
  options = {
    tablet.enable = lib.options.mkEnableOption 
        "OpenTabletDriver with systemd user service";
  };

  config = lib.mkIf config.tablet.enable {
    hardware.opentabletdriver.enable = true;
  };
}
