{ config, pkgs, ... }: let nixgl = import <nixgl> {};
in {
  home.username = "";
  home.homeDirectory = "";
  home.stateVersion = "23.05";

  home.packages = [
    pkgs.swayfx
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel
  ];

  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
}
