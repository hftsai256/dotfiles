{ config, pkgs, lib, ... }:
{
  options = {
    logitech.enable = lib.options.mkEnableOption "Logitech Unifying Receiver";
  };

  config = {
    hardware.logitech.wireless.enable = config.logitech.enable;

    environment.systemPackages = lib.mkIf config.logitech.enable [
      pkgs.solaar
    ];
  };
}
