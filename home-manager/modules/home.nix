{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) glSource;

in {
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    btop
    bat
    broot
    yazi
    tree
  ] ++ (if glSource == "nixgl" then with pkgs; [
    nixgl.auto.nixGLDefault
    nixgl.nixVulkanIntel
  ] else []);

  home.file = {
    ".local/bin" = {
      source = ../scripts;
      recursive = true;
    };
  };
}
