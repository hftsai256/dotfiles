{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    package = if (config.gfx == "native") then pkgs.mako else pkgs.null;
    font = "sans-serif 9";
    textColor = "#c5c8d9";
    backgroundColor = "#373b41c8";
    borderColor = "#5f819d";
    borderRadius = 4;
    defaultTimeout = 3000;
  };
}
