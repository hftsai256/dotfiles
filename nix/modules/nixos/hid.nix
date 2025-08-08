{ config, lib, ... }:
let
  cfg = config.hid;

in
{
  options = {
    hid.wacom.enable = lib.mkEnableOption "hid-wacom module for I2C touchscreen multitouch";
    hid.usb.enable = lib.mkEnableOption "USB HID device permission setup";
  };

  config = {
    hid.usb.enable = lib.mkDefault true;

    boot.kernelModules = lib.mkIf cfg.wacom.enable [ "wacom" ];
    boot.extraModprobeConfig = lib.mkIf cfg.wacom.enable ''
      softdep hid-generic post: wacom
    '';

    services.udev.extraRules =
      (lib.optionalString cfg.wacom.enable ''
        ACTION=="bind", SUBSYSTEM=="hid", KERNELS=="0018:056A:53F7.*", \
          RUN+="/bin/sh - c 'echo -n %k > /sys/bus/hid/drivers/hid-generic/unbind && modprobe wacom && echo -n %k > /sys/bus/hid/drivers/wacom/bind'"
      '') +
      (lib.optionalString cfg.usb.enable ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="02c0", MODE="0660", GROUP="dialout", TAG+="uaccess"
      '');
  };
}
