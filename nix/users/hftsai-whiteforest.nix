{ ... }:
{
  imports = [ ../modules/home ];

  fullName = "Halley Tsai";
  email = "htsai@cytonome.com";
  gfx = "native";

  term.app = "kitty";
  guiApps.enable = true;
  guiApps.eeLab.enable = false;
  guiApps.cadLab.enable = false;
  rime.enable = true;

  kanshiSettings = [
    { profile.name = "office";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        status = "enable";
        scale = 1.5;
        position = "1600,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = 1.2;
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
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = 1.2;
        position = "400,1440";
      }
    ]; }

    { profile.name = "4ktv";
      profile.outputs = [
      {
        criteria = "*";
        status = "enable";
        scale = 2.4;
        position = "0,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = 1.2;
        position = "0,0";
      }
    ]; }

    { profile.name = "standalone";
      profile.outputs = [
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = 1.2;
        position = "0,0";
      }
    ]; }
  ];
}

