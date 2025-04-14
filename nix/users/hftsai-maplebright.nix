{ pkgs, ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  guiApps.enable = true;
  rime.enable = true;

  # Steam Gamescope requires fonts to be linked under user's XDG path
  home.packages = [
    pkgs.source-han-sans
  ];

  kanshiSettings = [
    { profile.name = "home-desk";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL S2721QS FYCXM43";
        status = "enable";
        scale = 1.6;
        position = "0,0";
      }
    ]; }

    { profile.name = "home-TV";
      profile.outputs = [
      { 
        criteria = "*";
        status = "enable";
        scale = 2.0;
        position = "0,0";
      }
    ]; }

  ];
}

