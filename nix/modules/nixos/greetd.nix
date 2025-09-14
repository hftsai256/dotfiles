{ config, pkgs, lib, ... }:
let
  cfg = config.greetd;
  ecoSystem = lib.attrByPath ["hypr" "ecoSystem"] "gtk" config;

in
{
  options = {
    greetd.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Greetd display daemon with gtkgreet frontend
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time";
          user = "greeter";
        };
        terminal.vt = lib.mkForce 7;
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = (ecoSystem == "gtk");
    security.pam.services.greetd.enableKwallet = (ecoSystem == "kde");
  };
}
