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
    pkgs.blueman
  ];

  # Restart Bluetooth after hibernate/suspend-resume on Intel CNVi (XPS 9315)
  systemd.services."bluetooth-resume" = {
    description = "Restart Bluetooth after suspend/hibernate";
    wantedBy = [ "suspend.target" "hibernate.target" ];
    after = [ "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl restart bluetooth.service";
    };
  };
}
