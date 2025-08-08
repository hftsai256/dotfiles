{ pkgs, ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "nixgl";

  guiApps.enable = true;
  guiApps.eeLab.enable = false;
  term.app = "foot";

  home.packages = with pkgs; [
    xclip  # steamOS is still on X11
    mame-tools
  ];
}
