{ config, pkgs, lib, ... }:
{
  options = {
    gaming.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Install gaming infrastructures
      '';
    };

    gpuType = lib.options.mkOption {
      type = lib.types.enum [ "amd" "nvidia" "intel" "virgl" "headless" ];
      default = "intel";
      description = ''
        GPU vendor
      '';
    };
  };

  config = {
    hardware.graphics = lib.mkIf (config.gpuType != "headless") {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.amdvlk
        pkgs.amdenc
      ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    environment.systemPackages = lib.mkIf (config.gpuType != "headless") [
      pkgs.glxinfo
      pkgs.vulkan-tools
    ];

    programs.steam = lib.mkIf config.gaming.enable {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = config.gaming.enable;
    programs.corectrl.enable = (config.gpuType != "headless");
  };
}
