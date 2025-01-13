{ pkgs, ... }@inputs:
let
  user = "hftsai";
  hostName = "maplebright";

in
{
  imports = [
    inputs.jovian.nixosModules.default
    ./hardware-configuration.nix
  ];

  services.desktopManager.plasma6.enable = true;

  jovian = {
    hardware.has.amd.gpu = true;

    steam = {
      inherit user;
      enable = true;
    };

    decky-loader.enable = true;
  };

  hardware.xone.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "";
    initialHashedPassword = "$y$j9T$0nbU4IDxI6du0CtpiXVJn/$g2W7Pnf3/6l1zKzchsAkRe2Mgj8b1XhKhHTC7BWMpf9";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "dialout" ];
    shell = pkgs.zsh;
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "${user}" ];
  };

}
