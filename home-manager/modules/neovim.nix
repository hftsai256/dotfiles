{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

in
{
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      # Essential library
      plenary-nvim

      # Cosmetics
      lualine-nvim
      vim-hybrid
      nvim-web-devicons
      indent-o-matic

      # Navigation
      project-nvim
      nvim-tree-lua
      telescope-nvim
      telescope-fzy-native-nvim

      # LSP
      nvim-lspconfig
      lspsaga-nvim
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      nvim-cmp
      nvim-treesitter.withAllGrammars
      vim-nix

      # LSP: Language specific
      rustaceanvim
      clangd_extensions-nvim
      
      # Editing
      nvim-surround
    ];

    extraPackages = with pkgs; [
      python311Packages.python-lsp-server
      nodePackages.bash-language-server
      lua-language-server
      clang
      clang-tools
      nil
      nixpkgs-fmt
    ];
  };
}
