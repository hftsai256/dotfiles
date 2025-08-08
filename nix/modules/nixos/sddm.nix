{ config, pkgs, lib, ... }:
let
  cfg = config.sddm;

in
{
  options = {
    sddm.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        SDDM display manager
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "sapphire";
        loginBackground = true;
        userIcon = true;
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland.enable = true;
      theme = "catppuccin-mocha-sapphire";
      settings = {
        General.RememberLastSession = true;
        Users.RememberLastUser = true;
      };
    };
  };
}
