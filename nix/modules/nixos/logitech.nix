{ config, pkgs, lib, ... }:
{
  options = {
    logitech.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Set up Logitect Unifying Receiver
      '';
    };
  };

  config = {
    hardware.logitech.wireless.enable = config.logitech.enable;

    environment.systemPackages = lib.mkIf config.logitech.enable [
      pkgs.solaar
    ];
  };
}
