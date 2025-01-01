{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    source-han-sans
    source-han-serif
  ];

  xdg.configFile = {
    "fontconfig/conf.d/99-default-font-families.conf".source =
      mkOutOfStoreSymlink ./conf.d/99-default-font-families.conf;
  };
}
