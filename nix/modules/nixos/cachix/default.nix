{ pkgs, lib, ... }:
{
  imports = [
    ./nix-community.nix
  ];

  nix.settings.substituters = ["https://cache.nixos.org/"];
}
