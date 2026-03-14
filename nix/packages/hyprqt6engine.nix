{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, hyprutils
, hyprlang
, qt6Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprqt6engine";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprqt6engine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WSUMQmfVlpz31o2Tgfue0jnVRCeTrRi3Cy6s2/o8hzQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/hyprwm/hyprqt6engine/pull/4.patch";
      hash = "sha256-jmk3Po6n+sJYvs1XL/6spZJf7iHXKe2RW9u98LrL2m8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprlang
    hyprutils
    qt6Packages.qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    PLUGINDIR = "${placeholder "out"}/lib/qt-6/plugins";
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprqt6engine";
    description = "Qt6 theme provider for Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
