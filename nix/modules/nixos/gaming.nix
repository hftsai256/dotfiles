{ config, pkgs, lib, ... }:
let
  cfg = config.gaming;
  gpu = config.gpu;

in
{
  options = {
    gaming.enable = lib.options.mkEnableOption "Graphical stack for gaming";
    gaming.console.enable = lib.options.mkEnableOption "Console mode";
    gaming.gamescope.enable = lib.options.mkEnableOption "Enable Gamescope Session";
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

    exitGamescope = pkgs.writeShellScriptBin "steamos-session-select" ''
      #!/usr/bin/env bash
      session="''${1:-gamescope}"

      echo "[$(date)] steamos-session-select invoked with: $session" >> /tmp/steamos-switch.log

      # Stop graphical-session.target
      echo "Stopping graphical-session.target..." >> /tmp/steamos-switch.log
      systemctl --user stop graphical-session.target 2>&1 | tee -a /tmp/steamos-switch.log || true

      # Wait for all units to stop
      echo "Waiting for all graphical units to stop..." >> /tmp/steamos-switch.log
      while [ -n "$(systemctl --user --no-legend --state=deactivating list-units)" ]; do
        sleep 0.2
      done

      # Clean up systemd activation environment
      echo "Cleaning systemd activation environment..." >> /tmp/steamos-switch.log
      systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>&1 | tee -a /tmp/steamos-switch.log || true

      # Kill the D-Bus session to force a complete restart
      echo "Killing D-Bus session..." >> /tmp/steamos-switch.log
      systemctl --user stop dbus.service 2>&1 | tee -a /tmp/steamos-switch.log || true

      # Kill gamescope to return to greetd
      echo "Killing gamescope..." >> /tmp/steamos-switch.log
      pkill -9 gamescope
    '';

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

      gamescopeSession = {
        enable = lib.mkDefault cfg.gamescope.enable;
        steamArgs = [ "-tenfoot" "-pipewire-dmabuf" "-steamos3" ];
      };

      protontricks.enable = true;

      package = pkgs.steam.override {
        extraPkgs = pkgs: [
          exitGamescope
        ];

        extraProfile = ''
          export PATH=${exitGamescope}/bin:$PATH
        '';
      };
    };

    programs.gamescope = lib.mkIf cfg.gamescope.enable {
      enable = true;
      capSysNice = true;
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
