{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [  "Source Serif Pro" ];
      sansSerif = [ "Source Sans Pro" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    source-sans-pro
    source-serif-pro
    source-han-sans
    source-han-serif
    (pkgs.nerdfonts.override { 
      fonts = [ "NerdFontsSymbolsOnly" "FiraCode" ];
    })
  ];

  environment.systemPackages = with pkgs; [
    font-manager
  ];
}
