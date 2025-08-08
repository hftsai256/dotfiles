{ ... }:
{
  imports = [ ../modules/home ];

  fullName = "Halley Tsai";
  email = "htsai@cytonome.com";
  gfx = "native";

  hypr = {
    enable = true;
    ecoSystem = "kde";
  };
  guiApps.enable = true;
  guiApps.eeLab.enable = true;
  guiApps.cadLab.enable = true;
  rime.enable = true;

  kanshiSettings = [
    { profile.name = "office";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        status = "enable";
        scale = 1.6;
        position = "1280,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
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
        scale = 1.6;
        position = "0,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = 1.5;
        position = "560,1350";
      }
    ]; }

    { profile.name = "clamshell";
      profile.outputs = [
      {
        criteria = "*";
        status = "enable";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "disable";
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

