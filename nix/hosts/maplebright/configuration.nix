{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  gpu.type = "amd";
  gaming = {
    enable = true;
    gamescope.enable = true;
    console.enable = false;
    decky.enable = true;
  };

  greetd.enable = true;

  hypr.enable = true;
  hypr.ecoSystem = "kde";

  tablet.enable = true;
  mfp.enable = true;
  logitech.enable = true;

  virtualization = {
    enable = true;
    cpuType = "amd";
    vfio.enable = true;
    vfio.devs = [ "0000:0e:00.0" ];
  };

  hydra.enable = true;

  hostname = "maplebright";

  # Raphael iGPU only (1002:164e), not the 7800 XT. Initrd driver_override races amdgpu.
  boot.extraModprobeConfig = ''
    options vfio-pci ids=1002:164e
    softdep amdgpu pre: vfio-pci
  '';

  # Guest reboot does not reset Raphael. Rebind VFIO before each QEMU start.
  virtualisation.libvirtd.hooks.qemu.raphael-reset =
    pkgs.writeShellScript "raphael-reset" ''
      [ "$1" = win10-igpu ] || exit 0
      case "$2" in prepare|release) ;; *) exit 0 ;; esac
      rebind() {
        local d=$1
        echo 1 > /sys/bus/pci/devices/$d/reset 2>/dev/null || true
        echo $d > /sys/bus/pci/devices/$d/driver/unbind 2>/dev/null || true
        echo vfio-pci > /sys/bus/pci/devices/$d/driver_override 2>/dev/null || true
        echo $d > /sys/bus/pci/drivers/vfio-pci/bind 2>/dev/null || true
      }
      rebind 0000:0e:00.1
      rebind 0000:0e:00.0
    '';

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s\n";
}
