{
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) nixvim;
in {
  imports = [
    nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;
    defaultEditor = true;

    imports = [
      (import ./plugins.nix {inherit pkgs;})
      ./options.nix
      ./keymaps.nix
    ];

    performance = {
      combinePlugins.enable = true;
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

  programs.lazygit.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
