{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services = {
    udev.packages = with pkgs; [
      libmtp.out
      media-player-info
    ];
  };

  environment.systemPackages = [
    pkgs.blueberry
  ];
}
