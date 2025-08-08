{ lib
, stdenvNoCC
, fetchFromGitHub
, ... }:

stdenvNoCC.mkDerivation {
  pname = "orchis-kde";
  version = "2025-10-18";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "b2a96919eee40264e79db402b915f926436100ad";
    hash = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    # Kvantum themes
    mkdir -p $out/share/Kvantum
    cp -r Kvantum/* $out/share/Kvantum/

    # Color schemes
    mkdir -p $out/share/color-schemes
    cp -r color-schemes/*.colors $out/share/color-schemes/

    # Plasma desktop theme
    mkdir -p $out/share/plasma/desktoptheme
    cp -r plasma/desktoptheme/* $out/share/plasma/desktoptheme/

    # Look and feel
    mkdir -p $out/share/plasma/look-and-feel
    cp -r plasma/look-and-feel/* $out/share/plasma/look-and-feel/

    # Aurorae window decorations
    mkdir -p $out/share/aurorae/themes
    cp -r aurorae/* $out/share/aurorae/themes/

    # Wallpapers (optional, can omit if you don't want them)
    mkdir -p $out/share/wallpapers
    cp -r wallpaper/* $out/share/wallpapers/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Orchis theme for KDE Plasma";
    homepage = "https://github.com/vinceliuice/Orchis-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
