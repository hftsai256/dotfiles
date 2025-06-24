{ config, pkgs, lib, ... }:
{
  options = {
    yubikey.enable = lib.options.mkEnableOption "Yubikey support";
  };

  config = {
    hardware.gpgSmartcards.enable = config.yubikey.enable;

    environment.systemPackages = lib.optionals config.yubikey.enable (with pkgs; [
      yubikey-personalization
      yubioath-flutter
      yubikey-manager
    ]);

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services = lib.mkIf config.yubikey.enable {
      pcscd.enable = true;
      udev.packages = [
        pkgs.yubikey-personalization
      ];
    };

    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    security.pam.yubico = {
      enable = true;
      mode = "challenge-response";
      id = [ "24789592" ];
    };
  };
}
