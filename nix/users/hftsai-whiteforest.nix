{ pkgs, ... }:
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

  kanshiSettings = let
    homeRes = { x = 3840; y = 2160; r = 1.5; };
    officeRes = { x = 3840; y = 2160; r = 1.5; };
    laptopRes = { x = 1920; y = 1200; r = 1.2; };

    scale = res: {
      inherit (res) r;
      x = builtins.floor (res.x / res.r);
      y = builtins.floor (res.y / res.r);
    };

  in [
    { profile.name = "office";
      profile.outputs = [
      {
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        status = "enable";
        scale = officeRes.r;
        position = "${toString (scale laptopRes).x},0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = laptopRes.r;
        position = "0,0";
      }
    ]; }

    { profile.name = "home";
      profile.outputs = [
      {
        criteria = "Dell Inc. DELL S2721QS FYCXM43";
        status = "enable";
        scale = homeRes.r;
        position = "0,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "enable";
        scale = laptopRes.r;
        position =
          let
            dx = ((scale homeRes).x - (scale laptopRes).x) / 2;
            dy = (scale homeRes).y;
          in
            "${toString dx},${toString dy}";
      }
    ]; }

    { profile.name = "clamshell";
      profile.outputs = [
      {
        criteria = "Dell Inc. DELL S2721QS FYCXM43";
        status = "enable";
        scale = homeRes.r;
        position = "0,0";
      }
      {
        criteria = "Sharp Corporation 0x1548 Unknown";
        status = "disable";
      }
    ]; }

    { profile.name = "generic";
      profile.outputs = [
      {
        criteria = "*";
        status = "enable";
        scale = officeRes.r;
        position = "${toString (scale laptopRes).x},0";
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
        scale = laptopRes.r;
        position = "0,0";
      }
    ]; }
  ];
}

