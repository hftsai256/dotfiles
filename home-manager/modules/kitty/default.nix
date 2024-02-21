{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel
  ];

  programs.kitty = {
    font.name = "monospace";
    font.size = 10.0;
    shellIntegration.enableZshIntegration = true;
    theme = "hybrid";
  };
}
