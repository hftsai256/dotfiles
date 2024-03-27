{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

in
{
  # Workaround a bug introduced in v1.19.2 (issue #9579, PR #9723)
  # Need to symlink it manually before the PR is merged
  #xdg.configFile."nvim".source = mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/nvim";

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
      lsp-zero-nvim
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      nvim-cmp
      nvim-treesitter.withAllGrammars
      vim-nix

      # LSP: Language specific
      clangd_extensions-nvim
      coc-ltex
      ltex_extra-nvim
      
      # Editing
      nvim-surround
    ];

    extraPackages = with pkgs; [
      tree-sitter
      nodePackages.bash-language-server
      lua-language-server
      clang
      clang-tools
      nil
      ltex-ls
      nixpkgs-fmt
    ];
  };
}
