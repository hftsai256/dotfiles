{ config, lib, pkgs, ... }:
let
  cfg = config.touchscreen;

in {
  options = {
    touchscreen.enable = lib.mkEnableOption "touchscreen";
  };
}
