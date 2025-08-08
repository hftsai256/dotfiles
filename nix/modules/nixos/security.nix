{ config, pkgs, lib, ... }:
{
  options = {
    tpm2.enable = lib.options.mkEnableOption "Using tpm2 module";
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

    security.tpm2 = lib.mkIf config.tpm2.enable {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    security.pam.yubico = lib.mkIf config.yubikey.enable {
      enable = true;
      mode = "challenge-response";
      id = [ "24789592" ];
    };
  };
}
