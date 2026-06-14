{ pkgs, ... }:
{
  fullName = "Halley Tsai";
  email = "hftsai256@gmail.com";
  gfx = "native";

  term.app = "kitty";
  rime.enable = true;
  guiApps.enable = true;
  qs.enable = true;

  # Steam Gamescope requires fonts to be linked under user's XDG path
  home.packages = [
    pkgs.source-han-sans
  ];

  shikane.settings = {
    profile = [
      { name = "home";
        output = [
          { search = ["m=DELL S2721QS" "s=FYCXM43" "v=Dell Inc."];
            enable = true;
            scale = 1.5;
            position = "0,0";
          }
        ];
      }
      { name = "TV";
        output = [
          { search = "n/(DP|HDMI)-[1-9]$";
            enable = true;
            scale = 2.0;
            position = "0,0";
          }
        ];
      }
    ];
  };
}

