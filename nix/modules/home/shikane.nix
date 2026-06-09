{ config, lib, ... }:
{
  options = {
    shikane.enable = lib.mkEnableOption "Kanshi dynamic display management";
    shikane.settings = lib.mkOption {
      default = [];
      description = "Shikane settings.";
    };
  };

  config = let
    cfg = config.shikane;

  in lib.mkIf cfg.enable
  {
    services.shikane = {
      enable = true;
      settings = cfg.settings;
    };
  };
}
