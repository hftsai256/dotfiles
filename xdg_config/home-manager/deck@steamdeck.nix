{ config, pkgs, ... }:

let
  unstablepkgs = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;
    };
  };
  nixpkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };
  nixgl = import (builtins.fetchTarball "https://github.com/guibou/nixGL/archive/main.tar.gz") {};

in {
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel

    nixpkgs.direnv
    nixpkgs.fzf
    nixpkgs.ripgrep
    nixpkgs.btop
    nixpkgs.broot
    nixpkgs.kitty
    nixpkgs.xclip
    nixpkgs.rustup
    nixpkgs.nodejs_18
    nixpkgs.gcc
    nixpkgs.zoxide
    unstablepkgs.eza
    unstablepkgs.yazi

    nixpkgs.fira-code
    (nixpkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deck/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = [
      # Essential library
      nixpkgs.vimPlugins.plenary-nvim

      # Cosmetics
      nixpkgs.vimPlugins.lualine-nvim
      nixpkgs.vimPlugins.vim-hybrid
      nixpkgs.vimPlugins.nvim-web-devicons
      nixpkgs.vimPlugins.indent-o-matic

      # Navigation
      nixpkgs.vimPlugins.nvim-tree-lua
      nixpkgs.vimPlugins.telescope-nvim
      nixpkgs.vimPlugins.telescope-fzy-native-nvim

      # LSP
      nixpkgs.vimPlugins.lspsaga-nvim
      nixpkgs.vimPlugins.lsp-zero-nvim
      nixpkgs.vimPlugins.mason-nvim
      nixpkgs.vimPlugins.mason-lspconfig-nvim
      nixpkgs.vimPlugins.mason-tool-installer-nvim
      nixpkgs.vimPlugins.nvim-treesitter.withAllGrammars
      nixpkgs.vimPlugins.cmp-nvim-lsp
      nixpkgs.vimPlugins.nvim-cmp

      # Editing
      nixpkgs.vimPlugins.nvim-surround
    ];

    extraConfig = ''
      luafile ${./nvim/init.lua}
      luafile ${./nvim/lua/lsp.lua}
      luafile ${./nvim/lua/browsers.lua}
      luafile ${./nvim/lua/fuzzysearch.lua}
      luafile ${./nvim/lua/utils.lua}
    '';
  };
}
