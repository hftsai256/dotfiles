{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
{
  config = {
    xdg.configFile = {
      "fontconfig/conf.d/99-default-font-families.conf".source =
        mkOutOfStoreSymlink ./conf.d/99-default-font-families.conf;
    };
  };
}
