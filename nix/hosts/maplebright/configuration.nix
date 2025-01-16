{ pkgs, lib, ... }@inputs:
let
  user = "hftsai";
  hostName = "maplebright";

in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/cachix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/geographics.nix
    ../../modules/nixos/hydra.nix
    ../../modules/nixos/firefox.nix
  ];

  hydra.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  jovian = {
    hardware.has.amd.gpu = true;

    steam = {
      inherit user;
      enable = true;
      autoStart = true;
      desktopSession = "gnome";
    };

    decky-loader.enable = true;
  };

  hardware.xone.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Halley Tsai";
    initialHashedPassword = "$y$j9T$0nbU4IDxI6du0CtpiXVJn/$g2W7Pnf3/6l1zKzchsAkRe2Mgj8b1XhKhHTC7BWMpf9";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "dialout" ];
    shell = pkgs.zsh;
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
    interfaces.eno1.wakeOnLan.enable = true;
  };

  services.openssh.enable = true;

  programs.zsh.enable = true;

  firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "${user}" ];
  };

}
