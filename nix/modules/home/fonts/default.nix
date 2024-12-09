{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

in
{
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [
        "Symbols Nerd Font"
        "Fira Code"
        "Source Han Sans"
      ];
      serif = [
        "Symbols Nerd Font"
        "Noto Serif"
        "Source Han Serif"
      ];
      sansSerif = [
        "Symbols Nerd Font"
        "Noto Sans"
        "Source Han Sans"
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
