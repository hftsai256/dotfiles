{ config, lib, ... }:
{
  options = {
    tablet.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable OpenTabletDriver with systemd user service
      '';
    };
  };

  config = lib.mkIf config.tablet.enable {
    hardware.opentabletdriver.enable = true;
  };
}
