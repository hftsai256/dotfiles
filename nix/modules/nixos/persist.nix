{ config, pkgs, lib, ... }:
{
  etc."NetworkManager/system-connections" = {
    source = "/nix/persist/etc/NetworkManager/system-connections";
  };

  services.openssh = {
    hostKeys = [
      { path = "/nix/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      { path = "/nix/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /nix/persist/var/lib/bluetooth"
    "L /var/lib/cups/ppd - - - - /nix/persist/var/lib/cups/ppd"
    "L /var/lib/cups/ssl - - - - /nix/persist/var/lib/cups/ssl"
    "L /var/lib/sddm - - - - /nix/persist/var/lib/sddm"
  ];
}
