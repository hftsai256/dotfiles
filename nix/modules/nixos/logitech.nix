{ config, pkgs, lib, ... }:
{
  options = {
    logitech.enable = lib.options.mkEnableOption "Logitech Unifying Receiver";
  };

  config = lib.mkIf config.logitech.enable {
    environment.defaultPackages = [
      pkgs.solaar
    ];
  };
}
