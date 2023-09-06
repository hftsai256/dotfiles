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
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hftsai";
  home.homeDirectory = "/home/hftsai";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel
    nixpkgs.direnv

    #nixpkgs.fzf
    #nixpkgs.ripgrep
    #nixpkgs.btop
    #nixpkgs.lf
    #nixpkgs.neovim
    #nixpkgs.fira-code
    #(nixpkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    unstablepkgs.drawio
    unstablepkgs.azuredatastudio

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
  #  /etc/profiles/per-user/hftsai/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
