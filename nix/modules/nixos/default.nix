{ config, pkgs, lib, ... }:
{
  options = {
    kde.enable = lib.options.mkEnableOption "KDE Plasma desktop";
    gnome.enable = lib.options.mkEnableOption "Gnome desktop";
    opengl.enable = lib.options.mkEnableOption "GPU acceleration";

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
    ./boot.nix
    ./impermanence.nix
    ./secure-boot.nix
    ./thunderbolt.nix
    ./bluetooth.nix
    ./logitech.nix
    ./tablet.nix
    ./graphics.nix
    ./fwupd.nix
    ./geographics.nix
    ./network.nix
    ./mfp.nix
    ./security.nix
    ./fonts.nix
    ./virtualization.nix
    ./sddm.nix
    ./hypr
    ./firefox.nix
  ];

  config = {
    services = {
      desktopManager.plasma6.enable = config.kde.enable;
      xserver.desktopManager.gnome.enable = config.gnome.enable;
      flatpak.enable = true;
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
      usbutils
      pciutils
      lm_sensors
      efibootmgr
      v4l-utils
      libcamera
    ];

    programs.zsh.enable = true;

    firefox.enable = true;

    nixpkgs.config.allowUnfree = true;
    
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "${config.user}" ];
    };

    system.stateVersion = "24.11";
  };
}
