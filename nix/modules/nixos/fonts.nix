{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [  "Source Serif Pro" ];
      sansSerif = [ "Source Sans Pro" ];
      monospace = [ "Fira Code" ];
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    source-sans-pro
    source-serif-pro
    source-han-sans
    source-han-serif
    (pkgs.nerdfonts.override {
      fonts = [ "NerdFontsSymbolsOnly" ];
    })
  ];

  environment.systemPackages = with pkgs; [
    font-manager
  ];
}
