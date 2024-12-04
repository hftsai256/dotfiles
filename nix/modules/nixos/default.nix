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

    email = lib.options.mkOption {
      type = lib.types.nonEmptyStr;
      default = "hftsai256@gmail.com";
    };
  };

  imports = [
    ./boot.nix
    ./impermanence.nix
    ./secure-boot.nix
    ./bluetooth.nix
    ./logitech.nix
    ./tablet.nix
    ./graphics.nix
    ./fwupd.nix
    ./geographics.nix
    ./network.nix
    ./mfp.nix
    ./security.nix
    ./sddm.nix
    ./hypr
  ];

  config = {
    services.desktopManager.plasma6.enable = config.kde.enable;
    services.xserver.desktopManager.gnome.enable = config.gnome.enable;
    services.flatpak.enable = true;

    users.users.${config.user} = {
      isNormalUser = true;
      description = "Halley Tsai";
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
    ];

    programs.zsh.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "24.11";
  };
}
