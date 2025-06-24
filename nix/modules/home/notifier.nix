{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    package = if (config.gfx == "native") then pkgs.mako else pkgs.null;

    settings = {
      font = "sans-serif 9";
      text-color = "#c5c8d9";
      background-color = "#373b41c8";
      border-color = "#5f819d";
      border-radius = 4;
      default-timeout = 3000;
    };
  };
}
