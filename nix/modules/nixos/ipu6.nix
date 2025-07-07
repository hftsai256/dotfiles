{ config, pkgs, lib, ... }:
let
  cfg = config.ipu6;

in
{
  options = {
    ipu6.enable = lib.options.mkEnableOption ''Intel ipu6 camera platform'';
    ipu6.platform = lib.options.mkOption {
      type = lib.types.enum ["ipu6" "ipu6ep" "ipu6epmtl"];
      default = "ipu6";
      description = ''
        ipu6 platform - 
        * ipu6: Tiger Lake
        * ipu6ep: Alder Lake
        * ipu6epmtl:
        '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.ipu6 = {
      enable = true;
      platform = cfg.platform;
    };

    environment.systemPackages = with pkgs.gst_all_1; [
      pkgs.libcamera
      gstreamer
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
    ];

    services.pipewire.wireplumber = {
      enable = true;
    };
  };

}
