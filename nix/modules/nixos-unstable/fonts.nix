{ pkgs, ... }:
{
  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [  "Source Serif Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };

    fonts.packages = with pkgs; [
      noto-fonts
      source-sans-pro
      source-serif-pro
      source-han-sans
      source-han-serif
      nerd-fonts.symbols-only
    ];

    environment.systemPackages = with pkgs; [
      font-manager
    ];
  };
}
