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

        initial_session = lib.mkIf config.gaming.console.enable {
          command = "${pkgs.gamescope}/bin/gamescope --steam -- steam -tenfoot -steamos3 -pipewire-dmabuf";
          user = "hftsai";
        };

        terminal.vt = lib.mkForce 7;
      };
    };

    security.pam.services.greetd = {
      gnupg.enable = true;
      enableGnomeKeyring = (ecoSystem == "gtk");
      enableKwallet = (ecoSystem == "kde");
    };
  };
}
