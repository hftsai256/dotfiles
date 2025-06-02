{ config, lib, pkgs, ... }:
{
  options.rime.enable = lib.options.mkEnableOption "RIME on fcitx5";

  config.i18n.inputMethod = lib.mkIf config.rime.enable {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
}
