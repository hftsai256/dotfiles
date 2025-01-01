{ specialArgs, ... }:
let
  inherit (specialArgs) nixvim;

in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      ./plugins
      ./options.nix
      ./keymaps.nix
    ];

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "nvim-treesitter"
        ];
      };
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
