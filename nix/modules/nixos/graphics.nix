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
        enable32Bit = lib.mkOverride 150 config.gaming.enable;
        extraPackages = with pkgs; [
          amdenc
        ];
      };

      intel = {
        enable = true;
        enable32Bit = lib.mkOverride 150 config.gaming.enable;
        extraPackages = with pkgs; [
          vpl-gpu-rt
        ];
      };
    };

  in {
    hardware.graphics = graphics.${gpu.type};
    hardware.xone.enable = cfg.enable;

    environment.systemPackages = lib.optionals (gpu.type != "headless") [
      pkgs.glxinfo
      pkgs.vulkan-tools
    ];

    programs.steam = lib.mkIf cfg.enable {
      enable = true;
      gamescopeSession.enable = lib.mkDefault cfg.console.enable;
      protontricks.enable = true;
      extraPackages = [
        (pkgs.writeShellScriptBin "steamos-session-select" ''
          pkill gamescope
        '')
      ];
    };

    programs.corectrl.enable = (gpu.type == "amd");
    boot.kernelParams = lib.mkIf (gpu.type == "amd") [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.mcbp=0"
    ];
  };
}
