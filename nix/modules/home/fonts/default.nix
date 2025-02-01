{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
{
  config = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      fira-code
    ];

    xdg.configFile = {
      "fontconfig/conf.d/99-default-font-families.conf".source =
        mkOutOfStoreSymlink ./conf.d/99-default-font-families.conf;
    };
  };
}
