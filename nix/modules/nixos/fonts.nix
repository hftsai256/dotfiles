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
    source-sans-pro
    source-serif-pro
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    font-manager
  ];
}
