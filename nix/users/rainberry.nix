{ ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  guiApps.enable = true;
  guiApps.eeLab.enable = true;
  rime.enable = true;

  kanshiSettings = [
    { profile.name = "office";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        scale = 1.6;
        position = "1280,0";
      }
      {
        criteria = "AU Optronics 0x403D Unknown";
        scale = 1.5;
        position = "0,0";
      }
    ]; }

    { profile.name = "home";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL S2721QS FYCXM43";
        scale = 1.6;
        position = "0,0";
      }
      {
        criteria = "AU Optronics 0x403D Unknown";
        scale = 1.5;
        position = "560,1350";
      }
    ]; }

    { profile.name = "standalone";
      profile.outputs = [
      {
        criteria = "AU Optronics 0x403D Unknown";
        scale = 1.0;
        position = "0,0";
      }
    ]; }
  ];
}
