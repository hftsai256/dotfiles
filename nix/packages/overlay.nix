final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    qt6ct = prev.callPackage ./qt6ct-kde.nix { };
  });
  libsForQt5 = prev.libsForQt5.overrideScope (kfinal: kprev: {
    qt5ct = prev.callPackage ./qt5ct-kde.nix { };
  });
  hyprlandPlugins = prev.hyprlandPlugins // {
    hyprgrass = prev.hyprlandPlugins.hyprgrass.overrideAttrs (old: {
      version = "unstable-2026-03-24";

      src = prev.fetchFromGitHub {
        owner = "horriblename";
        repo = "hyprgrass";
        rev = "b1d05b8a6a2c2c701260a1b839a0916d595ed44a";
        hash = "sha256-UpUoQ2nioxYBDCCyk/ftSYk6w3r/Q1TdvdNgfRr5Tm0=";  # ← placeholder
      };
    });
  };
  hyprqt6engine = prev.callPackage ./hyprqt6engine.nix { };
  roland = prev.callPackage ./roland.nix { };
  openfortivpn-webview = prev.callPackage ./openfortivpn-webview.nix { };
  orchis-kde = prev.callPackage ./orchis-kde.nix { };
  decky-loader = prev.callPackage ./decky-loader.nix { };
}
