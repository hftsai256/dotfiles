{ config, pkgs, lib, ... }:
let
  cfg = config.screencast;

  miracastPorts = {
    tcp = [ 7236 7250 ];
    udp = [ 1900 5353 7236 ];
  };

  chromecastPorts = {
    tcp = [ 8008 8009 ];
    udp = [ 32768 32769 32770 32771 32772 ];
  };
in
{
  options = {
    screencast.enable = lib.options.mkEnableOption ''TV Projection (Miracast/Chromecast)'';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.gst_all_1; [
      gstreamer
      gst-plugins-ugly
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good

      pkgs.glib-networking
    ];

    environment.variables = {
      GIO_MODULE_DIR = "${pkgs.glib-networking}/lib/gio/modules";
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    networking.firewall = {
      allowedTCPPorts = miracastPorts.tcp ++ chromecastPorts.tcp;
      allowedUDPPorts = miracastPorts.udp ++ chromecastPorts.udp;
      trustedInterfaces = [ "p2p-wl*" ];
    };

  };

}

