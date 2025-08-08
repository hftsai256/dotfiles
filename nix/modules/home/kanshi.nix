{ config, lib, ... }:
{
  options = {
    kanshi.enable = lib.mkEnableOption "Kanshi dynamic display management";
    kanshi.settings = lib.mkOption {
      default = [];
      description = "Kanshi settings.";
    };
    kanshi.target = lib.mkOption {
      default = config.wayland.systemd.target;
      description = "Systemd target to bind to.";
    };
  };

  config = let
    cfg = config.kanshi;

  in lib.mkIf cfg.enable
  {
    services.kanshi = {
      enable = true;
      settings = cfg.settings;
    };
  };
}
