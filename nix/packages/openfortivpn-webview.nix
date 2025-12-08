{ stdenv,
  qt6,
  cmake,
  pkg-config,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfortivpn-webview";
  version = "1.2.3";

  src = fetchFromGitHub {
    repo = "openfortivpn-webview";
    owner = "gm-vm";
    rev = "894c3e94ecd99bd8aeca9f43495e1d6e3cdafc9b";
    hash = "sha256-CLcckVsKxpIE+zKwptrkWQpSK3f9j6eLdTtqph7W8Mw=";
  };

  sourceRoot = "${finalAttrs.src.name}/openfortivpn-webview-qt";

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  installPhase = ''
    install -d $out/bin
    mv ${finalAttrs.pname} $out/bin
  '';
})


