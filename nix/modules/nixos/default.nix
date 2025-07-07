{ config, pkgs, lib, ... }:
{
  options = {
    kde.enable = lib.options.mkEnableOption "KDE Plasma desktop";
    gnome.enable = lib.options.mkEnableOption "Gnome desktop";
    opengl.enable = lib.options.mkEnableOption "GPU acceleration";
    nixpkgs.unstable.enable = lib.options.mkEnableOption
      "use unstable branch of nixpkgs on system-level";

    hostname = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      default = "nixos";
    };

    user = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      default = "hftsai";
    };

    userFullName = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      default = "Halley Tsai";
    };

    email = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      default = "hftsai256@gmail.com";
    };
  };

  imports = [
    ./cachix
    ./hydra.nix
    ./boot.nix
    ./impermanence.nix
    ./secure-boot.nix
    ./thunderbolt.nix
    ./bluetooth.nix
    ./sigrok.nix
    ./logitech.nix
    ./tablet.nix
    ./graphics.nix
    ./geographics.nix
    ./network.nix
    ./ipu6.nix
    ./mfp.nix
    ./screencast.nix
    ./security.nix
    ./fonts.nix
    ./themes.nix
    ./virtualization.nix
    ./sddm.nix
    ./hypr
    ./niri.nix
    ./firefox.nix
  ];

  config = {
    services = {
      desktopManager.plasma6.enable = config.kde.enable;
      desktopManager.gnome.enable = config.gnome.enable;
      flatpak.enable = true;
      fwupd.enable = true;
      upower.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    users.users.${config.user} = {
      isNormalUser = true;
      description = config.userFullName;
      initialHashedPassword = "$y$j9T$0nbU4IDxI6du0CtpiXVJn/$g2W7Pnf3/6l1zKzchsAkRe2Mgj8b1XhKhHTC7BWMpf9";
      extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "dialout" ];
      shell = pkgs.zsh;
    };

    environment.systemPackages = with pkgs; [
      neovim
      git
      dig
      wget
      curl
      usbutils
      pciutils
      ethtool
      alsa-utils
      picocom
      lm_sensors
      efibootmgr
    ];

    programs = {
      kdeconnect.enable = true;
      dconf.enable = true;
      zsh.enable = true;
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 3d --keep 3";
        flake = "/home/${config.user}/.dotfiles/nix";
      };
    };

    firefox.enable = true;

    nixpkgs.config.allowUnfree = true;
    
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      trusted-users = [ "root" "${config.user}" ];
    };
  };
}
