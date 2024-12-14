{ config, lib, impermanence,... }:
{
  options = {
    impermanence.enable = lib.options.mkEnableOption "Impermanence module";
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
        "/var/lib/sbctl"
        "/var/lib/flatpak"
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/etc/ssh"
        "/etc/cups"
        "/etc/openfortivpn"
      ];

      files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];

    };
  };
}
