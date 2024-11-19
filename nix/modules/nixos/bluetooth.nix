{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  services = {
    blueman.enable = true;
    udev.packages = with pkgs; [
      libmtp.out
      media-player-info
    ];
  };
}
