{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) pkgsource;

in {
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    btop
    broot
    yazi
    tree
  ] ++ (if pkgsource == "nixgl" then with pkgs; [
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
