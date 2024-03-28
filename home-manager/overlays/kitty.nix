final: prev:
let
  sedCommand = ''
    sed -i 's/\(^Exec\s*=\s*\)\(kitty\)/\1nixGL \2 -1/g' $out/share/applications/kitty*.desktop
  '';

in {
  python3 = prev.python3.override {

    packageOverrides = self: super: {
      kitty-nixgl = super.kitty.overrideAttrs {
        fixupPhase = sedCommand;
      };
    };
  };

  kitty-nixgl = prev.kitty.overrideAttrs {
    fixupPhase = sedCommand;
  };
}
