{ config, pkgs, lib, ... }:
let
  cfg = config.gaming;
  gpu = config.gpu;

in
{
  options = {
    gaming.enable = lib.options.mkEnableOption "Graphical stack for gaming";
    gaming.console.enable = lib.options.mkEnableOption "Console mode";

    gpu.type = lib.options.mkOption {
      type = lib.types.enum [ "amd" "nvidia" "intel" "virgl" "headless" ];
      default = "intel";
      description = ''
        GPU vendor
      '';
    };
  };

  config = let
    graphics = {
      amd = {
        enable = true;
        enable32Bit = config.gaming.enable;
        extraPackages = with pkgs; [
          amdvlk
          amdenc
        ];
        extraPackages32 = lib.mkIf config.gaming.enable [
          pkgs.driversi686Linux.amdvlk
        ];
      };

      intel = {
        enable = true;
        enable32Bit = config.gaming.enable;
        extraPackages = with pkgs; [
          vpl-gpu-rt
        ];
      };
    };

  in {
    hardware.graphics = lib.mkIf cfg.enable graphics.${gpu.type};

    environment.systemPackages = lib.mkIf (gpu.type != "headless") [
      pkgs.glxinfo
      pkgs.vulkan-tools
    ];

    programs.steam = lib.mkIf cfg.enable {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.corectrl.enable = (gpu.type == "amd");
    boot.kernelParams = lib.mkIf (gpu.type == "amd") [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.mcbp=0"
    ];
  };
}
