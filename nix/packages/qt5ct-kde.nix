{ lib
, stdenv
, fetchurl
, cmake
, qt5
, libsForQt5
}:

stdenv.mkDerivation rec {
  pname = "qt5ct-kde";
  version = "1.8";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/qt5ct/qt5ct-${version}.tar.bz2";
    sha256 = "23b74054415ea4124328772ef9a6f95083a9b86569e128034a3ff75dfad808e9";
  };

  patches = [
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/qt5ct-shenanigans.patch?h=qt5ct-kde";
      sha256 = "7f38899f9c5c49db6ac1febda77ea0a1dd37e369f9cd21dd252723470fc86e06";
    })
  ];

  nativeBuildInputs = [
    cmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtsvg
    qt5.qtdeclarative
    qt5.qtquickcontrols2
    libsForQt5.kconfig
    libsForQt5.kconfigwidgets
    libsForQt5.kguiaddons
    libsForQt5.kiconthemes
  ];

  dontWrapQtApps = true;

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    CMAKE_INSTALL_PREFIX = "${placeholder "out"}";
    PLUGINDIR = "${placeholder "out"}/${qt5.qtbase.qtPluginPrefix}";
  };

  meta = {
    description = "Qt5 Configuration Tool";
    homepage = "https://sourceforge.net/projects/qt5ct/";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "qt5ct";
  };
}
