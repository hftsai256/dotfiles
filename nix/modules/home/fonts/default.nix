{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [
        "Fira Code"
        "Source Han Sans"
        "Symbols Nerd Font"
      ];
      serif = [
        "Noto Serif"
        "Source Han Serif"
        "Symbols Nerd Font"
      ];
      sansSerif = [
        "Noto Sans"
        "Source Han Sans"
        "Symbols Nerd Font"
      ];
      emoji = [
        "Noto Color Emoji"
        "Symbols Nerd Font"
      ];
    };
  };

  home.packages = with pkgs; [
    fira-code
    fira-sans
    noto-fonts
    source-han-sans
    source-han-serif
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
  ];
}
