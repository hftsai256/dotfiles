{ ... }:
{
  imports = [
    ../nixos
    ./fonts.nix
  ];

  config = {
    disabledModules = [ ../nixos/fonts.nix ];
  };
}
