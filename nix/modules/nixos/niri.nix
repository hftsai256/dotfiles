{ config, pkgs, lib, ... }:
{
  options = {
    niri.enable = lib.mkEnableOption "Niri compositor";
  };

  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;

    security = {
      polkit.enable = true;
      pam.services.login.enableGnomeKeyring = true;
    };

  };
}
