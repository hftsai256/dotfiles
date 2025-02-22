{ config, lib, ... }:
{
  options = {
    logitech.enable = lib.options.mkEnableOption "Logitech Unifying Receiver";
  };

  config = lib.mkIf config.logitech.enable {
    services.solaar.enable = true;
  };
}
