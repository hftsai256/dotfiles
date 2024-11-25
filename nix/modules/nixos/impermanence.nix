{ config, pkgs, lib, impermanence,... }:
{
  options = {
    impermanence.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable impermanence config
      '';
    };
  };

  imports = [
    impermanence.nixosModules.impermanence
  ];

  config = {
    environment.persistence."/persist" = {
      enable = config.impermanence.enable;
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/cups/ppd"
        "/var/lib/cups/ssl"
        "/var/lib/systemd/coredump"
        "/var/lib/flatpak"
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/etc/secureboot"
        "/etc/openfortivpn"
      ];

      files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];

    };
  };
}
