{ config, pkgs, lib, specialArgs, ... }:
{
  options = {
    gfx = lib.options.mkOption {
      type = lib.types.enum ["native" "nixgl" "null"];
      default = "native";
      description = ''
        Graphics backend. Must be one of the followings:
          "native": running native nixos
          "nixgl": gfx is bridged over nixgl
          "null": gfx-dependent applications will be provided elsewhere
      '';
    };

    guiApps.enable = lib.options.mkEnableOption "GUI apps";
    guiApps.eeLab.enable = lib.options.mkEnableOption "EE Lab tools";

    fullName = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      description = "User full name";
    };

    email = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      description = "User email address";
    };
  };

  imports = [
    ./nixvim
    ./hypr
    ./fonts
    ./zsh
    ./term.nix
    ./rime.nix
    ./flatpak.nix
  ];

  config = {
    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = config.fullName;
        userEmail = config.email;
      };
    };

    home.packages = with pkgs; [
      ripgrep
      fd
      btop
      bat
      broot
      yazi
      tree
    ] ++

    lib.optionals (config.gfx == "nixgl") [
      nixgl.auto.nixGLDefault
      nixgl.nixVulkanIntel
    ] ++

    lib.optionals config.guiApps.enable [
      brave
      thunderbird
      teams-for-linux
      mpv

      gnome-network-displays
      simple-scan

      solaar
      selectdefaultapplication

      remmina
      libreoffice
    ] ++

    lib.optionals (config.guiApps.enable && config.guiApps.eeLab.enable) [
      kicad
      ngspice
    ];

    home.file = {
      ".local/bin" = {
        source = ../../scripts;
        recursive = true;
      };
    };

    home.sessionPath = [ "$HOME/.local/bin" ];

    services.mpris-proxy.enable = true;
  };
}
