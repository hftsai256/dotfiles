{ pkgs, ... }:
{
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "v4l" "escl" ];
  };

  services.printing.enable = true;
}
