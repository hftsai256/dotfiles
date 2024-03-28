# Override packages to acoomodate nixGL or separately installed packages

final: prev:
let
  prefixNixGL = pname: 
  ''
    sed -i 's/\(^Exec\s*=\s*\)\(${pname}\)/\1nixGL \2 -1/g' $out/share/applications/${pname}*.desktop
  '';

in {
  python3 = prev.python3.override {

    packageOverrides = self: super: {
      kitty = super.kitty.overrideAttrs {
        fixupPhase = prefixNixGL super.kitty.pname;
      };
    };
  };

  kitty = prev.kitty.overrideAttrs {
    fixupPhase = prefixNixGL prev.kitty.pname;
  };

  null = prev.runCommand "null" {} ''
    mkdir -p $out/tmp
    touch $out/tmp/null
  '';
}
