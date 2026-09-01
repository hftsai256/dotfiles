{ config, lib, ... }:
{
  options = {
    hydra.enable = lib.options.mkEnableOption "local build/cache server";
  };

  config.nix = lib.mkIf config.hydra.enable {
    buildMachines = [ {
      hostName = "hydra.trusted.internal";
      sshUser = "remotebuild";
      systems = ["x86_64-linux" "aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 24;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [];
    } ];

    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
