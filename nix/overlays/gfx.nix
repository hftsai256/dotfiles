# Override packages to acoomodate nixGL or separately installed packages

final: prev:
let
  prefixNixGL = pname: ''
    sed -i 's/\(^Exec\s*=\s*\)\(${pname}\)/\1nixGL \2/g' $out/share/applications/*.desktop
  '';

  patchGlDesktopEntry = app:
    app.overrideAttrs {
      postInstall = (
        if builtins.hasAttr "postInstall" app then app.postInstall else ""
        ) + prefixNixGL app.pname;
    };

in {
  python3 = prev.python3.override {
    packageOverrides = self: super: {
      kitty-nixgl = patchGlDesktopEntry super.kitty;
    };
  };

  kitty-nixgl = patchGlDesktopEntry prev.kitty;

  alacritty-nixgl = patchGlDesktopEntry prev.alacritty;

  foot-nixgl = patchGlDesktopEntry prev.foot;

  null = prev.runCommand "null" {} ''
    mkdir -p $out/tmp
    touch $out/tmp/null
  '';
}
