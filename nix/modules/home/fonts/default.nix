{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
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


  xdg.configFile = {
    "fontconfig/conf.d/99-aliases.conf".source =
      mkOutOfStoreSymlink ./conf.d/99-aliases.conf;
  };

  home.packages = with pkgs; [
    fira-code
    fira-sans
    inter
    source-han-sans
    source-han-serif
    nerd-fonts.symbols-only

    font-manager
  ];
}
