{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
  };

  home.packages = [
    pkgs.fira-code
    (pkgs.nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
  ];

  xdg.configFile."fontconfig" = {
    source = ./fontconfig;
    recursive = true;
  };
}
