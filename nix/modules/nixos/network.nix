{ config, ... }:
{
  networking = {
    hostName = config.hostname;
    networkmanager.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    openssh.enable = true;

    samba.enable = true;
    samba-wsdd.enable = true;
  };
}
