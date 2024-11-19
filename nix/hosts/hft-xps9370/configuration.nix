{ config, pkgs, nixos-hardware, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/hypr
      nixos-hardware.nixosModules.dell-xps-13-9370
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "v4l" "escl" ];
    };

    gpgSmartcards.enable = true;
  };

  networking = {
    hostName = "hft-xps9370"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.users.hftsai = {
    isNormalUser = true;
    description = "Halley Tsai";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
    shell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
      neovim 
      git
      wget
      usbutils
      pciutils
      lm_sensors
    ];

  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  services = {
    openssh.enable = true;
    blueman.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
      libmtp.out
      media-player-info
    ];
  };

  hypr.lowSpec = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}
