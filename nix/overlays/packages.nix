final: prev: {
  hyprqt6engine = prev.callPackage ../packages/hyprqt6engine.nix { };
  openfortivpn-webview = prev.callPackage ../packages/openfortivpn-webview.nix { };
  orchis-kde = prev.callPackage ../packages/orchis-kde.nix { };
}
