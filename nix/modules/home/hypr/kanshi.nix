{ config, lib, ... }:
{
  options = {
    kanshiSettings = lib.mkOption {
      default = [];
      description = "Kanshi settings";
    };
  };

  config.services.kanshi = {
    enable = true;
    settings = config.kanshiSettings;
  };
}
