{ ... }:
let
  sources = {
    librime-lua = {
      pname = "librime-lua";
      version = "20ddea907e0b0c9c60d1dcb6b102bee38697cb5c";
      src = pkgs.fetchFromGitHub {
        owner = "hchunhui";
        repo = "librime-lua";
        rev = "20ddea907e0b0c9c60d1dcb6b102bee38697cb5c";
        fetchSubmodules = false;
        sha256 = "sha256-kU3pceqQoIM4pypPg2nLLnnyrgQSUEWZW9VLmmPJltU=";
      };
      date = "2024-03-08";
    };

    librime-proto = {
      pname = "librime-proto";
      version = "657a923cd4c333e681dc943e6894e6f6d42d25b4";
      src = pkgs.fetchFromGitHub {
        owner = "lotem";
        repo = "librime-proto";
        rev = "657a923cd4c333e681dc943e6894e6f6d42d25b4";
        fetchSubmodules = false;
        sha256 = "sha256-HdypebfmzreSdEQBwbvRG6sJZPASP+e8Tew+GrMnpOQ=";
      };
      date = "2023-10-17";
    };
  };

  librime_overlay = 
    (final: prev: {
      librime = (prev.librime.override {
        plugins = [
          (sources.librime-lua.src.overrideAttrs (old: {
            name = "librime-lua";
          }))
          (sources.librime-proto.src.overrideAttrs (old: {
            name = "librime-proto";
          }))
        ];
      }).overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.luajit ];
        meta = old.meta // {
          description = "Librime with plugins (librime-lua, librime-proto)";
        };
      });
    });

  pkgs = import <nixpkgs> {
    overlays = [ librime_overlay ];
  };

in {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
}
