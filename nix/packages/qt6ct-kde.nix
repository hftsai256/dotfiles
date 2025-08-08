{ lib
, stdenv
, fetchgit
, fetchurl
, cmake
, qt6
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "qt6ct-kde";
  version = "0.11";

  src = fetchgit {
    url = "https://www.opencode.net/trialuser/qt6ct";
    rev = "refs/tags/${version}";
    hash = "sha256-x9jLoh3gAsJuSZXnIimUsxZaobiNYYB1UIAwy0HqDp4=";
  };

  patches = [
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/qt6ct-shenanigans.patch?h=qt6ct-kde";
      hash = "sha256-VZMCRsVKlL4Ch13CG8V+ns+37xukASARKwqomJKN/cU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtdeclarative
    kdePackages.qqc2-desktop-style
  ];

  dontWrapQtApps = true;

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    PLUGINDIR = "${placeholder "out"}/lib/qt-6/plugins";
  };

  meta = with lib; {
    description = "Qt 6 Configuration Utility, patched to work correctly with KDE applications";
    homepage = "https://www.opencode.net/trialuser/qt6ct";
    license = licenses.bsd2;
    platforms = platforms.linux;
    mainProgram = "qt6ct";
  };
}
