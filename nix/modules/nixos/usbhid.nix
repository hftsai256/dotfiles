{ lib, ... }:
{
  options = {
    usbhid.enable = lib.options.mkEnableOption "USB HID device permission setup for udev";
  };

  config = {
    usbhid.enable = lib.mkDefault true;

    services.udev.extraRules = ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="02c0", MODE="0660", GROUP="dialout", TAG+="uaccess"
    '';
  };
}
