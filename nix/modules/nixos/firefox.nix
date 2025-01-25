{ config, pkgs, lib, nixpkgs-unstable, ... }:
let
  pkgsUnstable = import nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };

in {
  options = {
    firefox.enable = lib.options.mkEnableOption "Firefox";
  };

  config = {
    environment.systemPackages = lib.mkIf config.firefox.enable [
      pkgsUnstable.firefoxpwa
    ];

    programs.firefox = lib.mkIf config.firefox.enable {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts.packages = [ pkgsUnstable.firefoxpwa ];
    };
  };
}
