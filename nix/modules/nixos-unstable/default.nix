{ ... }:
{
  imports = [
    ../nixos
    ./fonts.nix
  ];

  disabledModules = [ ../nixos/fonts.nix ];
}
