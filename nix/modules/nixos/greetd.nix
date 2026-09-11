{ config, pkgs, lib, ... }:
let
  cfg = config.greetd;

in
{
  options = {
    greetd.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Greetd with Noctalia Greeter
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        user.default = config.user;
        session.default = "Hyprland";
        keyboard.layout = "us";
        cursor = {
          theme = "Simp1e-Breeze-Dark";
          size = 24;
          path = "${pkgs.simp1e-cursors}/share/icons";
        };
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        initial_session = lib.mkIf config.gaming.console.enable {
          command = "${pkgs.gamescope}/bin/gamescope --steam --xwayland-count 2 -- steam -gamepadui -steamos3 -pipewire-dmabuf";
          user = config.user;
        };

        terminal.vt = lib.mkForce 7;
      };
    };

    security.pam.services.greetd = {
      gnupg.enable = true;
      enableGnomeKeyring = true;
    };
  };
}
