{ config, pkgs, lib, ... }:
{
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
      
      # Editing
      nvim-surround
    ];

    extraPackages = with pkgs; [
      python311Packages.python-lsp-server
      nodePackages.bash-language-server
      lua-language-server
      rust-analyzer
      nil
      nixpkgs-fmt
    ];

    extraConfig = ''
      luafile ${./init.lua}
      luafile ${./lua/lsp.lua}
      luafile ${./lua/browsers.lua}
      luafile ${./lua/keybindings.lua}
      luafile ${./lua/fuzzysearch.lua}
      luafile ${./lua/utils.lua}
    '';
  };
}
