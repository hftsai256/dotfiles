{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Halley Tsai";
    userEmail = "hftsai256@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    brave
    firefox
    thunderbird
    teams-for-linux
    mpv
    obs-studio
    naps2
    libreoffice
  ];

  hypr.lowSpec = true;

  kanshiSettings = [
    { profile.name = "office";
      profile.outputs = [
      { 
        criteria = "Dell Inc. DELL P2723QE 24QVXV3";
        scale = 1.6;
        position = "1280,0";
      }
      {
        criteria = "Sharp Corporation 0x148B Unknown";
        scale = 3.0;
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
        criteria = "Sharp Corporation 0x148B Unknown";
        scale = 3.0;
        position = "560,1350";
      }
    ]; }

    { profile.name = "standalone";
      profile.outputs = [
      {
        criteria = "Sharp Corporation 0x148B Unknown";
        scale = 2.0;
        position = "0,0";
      }
    ]; }
  ];

  imports = [
    ../modules/home/nixvim
    ../modules/home/term.nix
    ../modules/home/rime.nix
    ../modules/home/hypr
    ../modules/home/fonts
    ../modules/home/zsh
  ];
}