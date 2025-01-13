{ ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  hypr.enable = true;
  guiApps.enable = true;
  rime.enable = true;

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

