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

  };

  config = {
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      ripgrep
      fd
      btop
      bat
      broot
      yazi
      tree
    ] ++ lib.optionals (config.gfx == "nixgl") [
      nixgl.auto.nixGLDefault
      nixgl.nixVulkanIntel
    ];

    home.file = {
      ".local/bin" = {
        source = ../../scripts;
        recursive = true;
      };
    };

    services.mpris-proxy.enable = true;
  };
}
