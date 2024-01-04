{ config, pkgs, lib, ... }:
let
  pluginGit = ref: rev: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in {
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    plugins = with pkgs; [
      # Essential library
      vimPlugins.plenary-nvim

      # Cosmetics
      vimPlugins.lualine-nvim
      vimPlugins.vim-hybrid
      vimPlugins.nvim-web-devicons
      vimPlugins.indent-o-matic

      # Navigation
      vimPlugins.project-nvim
      vimPlugins.nvim-tree-lua
      vimPlugins.telescope-nvim
      vimPlugins.telescope-fzy-native-nvim

      # LSP
      vimPlugins.lspsaga-nvim
      vimPlugins.lsp-zero-nvim
      vimPlugins.mason-nvim
      vimPlugins.mason-lspconfig-nvim
      vimPlugins.mason-tool-installer-nvim
      vimPlugins.cmp-nvim-lsp
      vimPlugins.nvim-cmp
      vimPlugins.nvim-treesitter.withAllGrammars

      # Editing
      vimPlugins.nvim-surround
    ];

    extraConfig = ''
      luafile ${./init.lua}
      luafile ${./lua/lsp.lua}
      luafile ${./lua/browsers.lua}
      luafile ${./lua/fuzzysearch.lua}
      luafile ${./lua/utils.lua}
    '';
  };
}
