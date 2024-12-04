{ config, lib, ... }:
{
  options = {
    thunderbolt.enable = lib.options.mkEnableOption "Thunderbolt";
  };

  config.services.hardware.bolt.enable = config.thunderbolt.enable;
}
