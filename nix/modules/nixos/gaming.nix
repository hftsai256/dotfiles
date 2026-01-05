{ config, pkgs, lib, ... }:
let
  cfg = config.gaming;
  gpu = config.gpu;

in
{
  options = {
    gaming.enable = lib.options.mkEnableOption "Graphical stack for gaming";
    gaming.console.enable = lib.options.mkEnableOption "Console mode";
    gaming.decky = {
      enable = lib.options.mkEnableOption "Integrate Decky-Loader";

      user = lib.mkOption {
        type = lib.types.str;
        default = config.user;
        description = ''
          The default user for decky-loader
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.decky-loader;
        defaultText = lib.literalExpression "pkgs.decky-loader";
        description = ''
          The loader package to use.
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/home/${cfg.decky.user}/.local/state/decky-loader";
        description = ''
          Directory to store plugins and data.
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        example = lib.literalExpression "[ pkgs.curl pkgs.unzip ]";
        default = [];
        description = ''
          Extra packages to add to the service PATH.
        '';
      };

      extraPythonPackages = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        example = lib.literalExpression "pythonPackages: with pythonPackages; [ hid ]";
        default = _: [];
        defaultText = lib.literalExpression "pythonPackages: []";
        description = ''
          Extra Python packages to add to the PYTHONPATH of the loader.
        '';
      };
    };

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
      pkgs.mesa-demos
      pkgs.vulkan-tools
    ] ++ lib.optionals (cfg.decky.enable) [
      pkgs.python3
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

    systemd.services.decky-loader = lib.mkIf cfg.decky.enable {
      description = "Steam Deck Plugin Loader";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        UNPRIVILEGED_USER = cfg.decky.user;
        UNPRIVILEGED_PATH = cfg.decky.stateDir;
        PLUGIN_PATH = "${cfg.decky.stateDir}/plugins";
      };

      path = cfg.decky.extraPackages;

      preStart = ''
        mkdir -p "${cfg.decky.stateDir}/plugins"
        mkdir -p "${cfg.decky.stateDir}/settings"
        chown -R "${cfg.decky.user}:users" "${cfg.decky.stateDir}"
      '';

      serviceConfig = {
        ExecStart = "${cfg.decky.package}/bin/decky-loader";
        KillMode = "process";
        TimeoutStopSec = 45;
      };
    };

    programs.corectrl.enable = (gpu.type == "amd");
    boot.kernelParams = lib.mkIf (gpu.type == "amd") [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.mcbp=0"
    ];
  };
}
