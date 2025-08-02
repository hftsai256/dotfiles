final: prev: {
  libcamera = prev.libcamera.overrideAttrs (oldAttrs: {
    postFixup = ''
      ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa/ipa_*.so
    '';
  });
}
