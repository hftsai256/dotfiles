final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    qt6ct = prev.callPackage ./qt6ct-kde.nix { };
  });
  openfortivpn-webview = prev.callPackage ./openfortivpn-webview.nix { };
  orchis-kde = prev.callPackage ./orchis-kde.nix { };
  decky-loader = prev.callPackage ./decky-loader.nix { };
}
