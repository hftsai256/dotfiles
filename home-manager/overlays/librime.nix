final: prev: {
  librime = (prev.librime.override {
    plugins = [
      (final.sources.librime-lua.src.overrideAttrs (old: {
        name = "librime-lua";
      }))
      (final.sources.librime-proto.src.overrideAttrs (old: {
        name = "librime-proto";
      }))
    ];
  }).overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.pkgs.luajit ];
    meta = old.meta // {
      description = "Librime with plugins (librime-lua, librime-proto)";
    };
  });
}

