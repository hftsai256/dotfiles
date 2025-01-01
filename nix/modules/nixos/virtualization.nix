{ config, lib, pkgs, ... }:
{
  options.virtualization = {
    enable = lib.options.mkEnableOption "virtualization";
    lookingGlass = lib.options.mkEnableOption "Looking Glass for Windows clients";

    cpuType = lib.options.mkOption {
      type = lib.types.enum [ "intel" "amd" ];
      default = "intel";
      description = ''
        CPU vendor for appropriate kernel parameters
      '';
    };

    vfio = {
      enable = lib.options.mkEnableOption "enable vfio passthrough";
      devs = lib.options.mkOption {
        type = lib.types.listOf lib.types.nonEmptyStr;
        default = [];
        description = ''
          PCIe addresses for IOMMU passthrough
        '';
      };
    };
  };

  config =
  let
    inherit (builtins) concatStringsSep;

    cfg = config.virtualization;

    kernelParams = {
      intel = [ "intel_iommu=on" ];
      amd = [ "amd_iommu=on" ];
    };

    kernelModules = {
      intel = [ "kvm-intel" ];
      amd = [ "kvm-amd" ];
    };

  in lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.virt-manager
      pkgs.swtpm
      pkgs.OVMF
    ] ++ lib.optionals cfg.lookingGlass [
      pkgs.looking-glass-client
      pkgs.scream
    ];

    users.users.${config.user}.extraGroups = [ "libvirtd" ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          ovmf = {
            enable = true;
            packages = [ (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd ];
          };
          swtpm.enable = true;
          package = pkgs.qemu_kvm;
          runAsRoot = true;
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    boot.kernelParams = kernelParams.${cfg.cpuType} ++
      lib.optionals cfg.vfio.enable [ "pcie_aspm=off" "iommu=pt" ];

    boot.kernelModules = kernelModules.${cfg.cpuType} ++
      lib.optionals cfg.vfio.enable [ "vfio-pci" ];

    boot.initrd.preDeviceCommands = lib.mkIf (cfg.vfio.enable && cfg.vfio.devs != []) ''
      DEVS=${concatStringsSep " " cfg.vfio.devs}
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';

    # setting up shared memory for Looking Glass framebuffer
    # include the following configuration to the virtual machine:
    # <shmem name='looking-glass'>
    #   <model type='ivshmem-plain'/>
    #   <size unit='M'>32</size>
    #   <address type='pci' domain='0x0000' bus='0x0b' slot='0x01' function='0x0'/>
    # </shmem>
    # <shmem name='scream'>
    #   <model type='ivshmem-plain'/>
    #   <size unit='M'>2</size>
    #   <address type='pci' domain='0x0000' bus='0x0b' slot='0x02' function='0x0'/>
    # </shmem>
    systemd.tmpfiles.rules = lib.mkIf cfg.lookingGlass [
      "f /dev/shm/looking-glass 0660 ${config.user} qemu-libvirtd -"
      "f /dev/shm/scream 0660 ${config.user} qemu-libvirtd -"
    ];

    systemd.user.services.scream-ivshmem = lib.mkIf cfg.lookingGlass {
      enable = true;
      description = "Scream IVSHMEM";
      serviceConfig = {
        ExecStart = "${pkgs.scream}/bin/scream /dev/shm/scream";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
      requires = [ "pulseaudio.service" ];
    };
  };
}
