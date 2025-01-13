{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
{
  config = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      fira-code
      (pkgs.nerdfonts.override {
        fonts = [ "NerdFontsSymbolsOnly" "FiraCode" ];
      })
    ];

    xdg.configFile = {
      "fontconfig/conf.d/99-default-font-families.conf".source =
        mkOutOfStoreSymlink ./conf.d/99-default-font-families.conf;
    };
  };
}
