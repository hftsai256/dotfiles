{ ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  niri.enable = true;
  term.app = "kitty";
  guiApps.enable = true;
  guiApps.eeLab.enable = true;
  rime.enable = true;

  kanshiSettings = [
    { profile.name = "office";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        status = "enable";
        scale = 1.5;
        position = "1280,0";
      }
      {
        criteria = "AU Optronics 0x403D Unknown";
        status = "enable";
        scale = 1.5;
        position = "0,0";
      }
    ]; }

    { profile.name = "home";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL S2721QS FYCXM43";
        status = "enable";
        scale = 1.5;
        position = "0,0";
      }
      {
        criteria = "AU Optronics 0x403D Unknown";
        status = "enable";
        scale = 1.2;
        position = "480,1440";
      }
    ]; }

    { profile.name = "clamshell";
      profile.outputs = [
      {
        criteria = "*";
        status = "enable";
      }
      {
        criteria = "AU Optronics 0x403D Unknown";
        status = "disable";
      }
    ]; }

    { profile.name = "standalone";
      profile.outputs = [
      {
        criteria = "AU Optronics 0x403D Unknown";
        status = "enable";
        scale = 1.2;
        position = "0,0";
      }
    ]; }
  ];
}
