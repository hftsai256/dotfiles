{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel
  ];

  programs.kitty = {
    enable = true;

    font.name = "monospace";
    font.size = 10;
  };
}
