{ installDrive ? "/dev/nvme0n1", swapSize ? "32G", ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "${installDrive}";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "${swapSize}"; #
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "enc";
              settings.allowDiscards = true;

              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "primary" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress-force=zstd:3" "noatime" ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress-force=zstd:3" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress-force=zstd:3" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };

  fileSystems."/persist" = {
    neededForBoot = true;
  };
}
