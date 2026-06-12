{ ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  term.app = "kitty";
  rime.enable = true;
  guiApps.enable = true;
  qs.enable = true;

  services.roland.enable = true;

  shikane.settings = let
    homeRes   = { x = 3840; y = 2160; r = 1.5; };
    officeRes = { x = 3840; y = 2160; r = 1.5; };
    laptopRes = { x = 1920; y = 1200; r = 1.2; };
    builtinDisplay = "n=eDP-1";
    scale = res: {
      inherit (res) r;
      x = builtins.floor (res.x / res.r);
      y = builtins.floor (res.y / res.r);
    };

  in {
    profile = [
      { name = "office";
        output = [
          { search = ["m=DELL P2723QE" "s=24QVXV3" "v=Dell Inc."];
            enable = true;
            scale = officeRes.r;
            position = "${toString (scale laptopRes).x},0";
          }
          { search = builtinDisplay;
            enable = true;
            scale = laptopRes.r;
            position = "0,0";
          }
        ];
      }
      { name = "home";
        output = [
          { search = ["m=DELL S2721QS" "s=FYCXM43" "v=Dell Inc."];
            enable = true;
            scale = homeRes.r;
            position = "0,0";
          }
          { search = builtinDisplay;
            enable = true;
            scale = laptopRes.r;
            position = let
              dx = ((scale homeRes).x - (scale laptopRes).x) / 2;
              dy = (scale homeRes).y;
            in "${toString dx},${toString dy}";
          }
        ];
      }
      { name = "clamshell";
        output = [
          { search = "n/(DP|HDMI)-[1-9]$";
            enable = true;
            scale = homeRes.r;
            position = "0,0";
          }
          { search = builtinDisplay;
            enable = false;
          }
        ];
      }
      { name = "standalone";
        output = [
          { search = builtinDisplay;
            enable = true;
            scale = laptopRes.r;
            position = "0,0";
          }
        ];
      }
    ];
  };

}
