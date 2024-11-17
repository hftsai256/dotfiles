{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fira-code
    fira-sans
    noto-fonts
    source-han-sans
    source-han-serif
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
  ];

  xdg.configFile."fontconfig" = {
    source = ./fontconfig;
    recursive = true;
  };
}
