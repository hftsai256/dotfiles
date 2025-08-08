{ lib
, fetchFromGitHub
, rustPlatform
, writeText
, pkg-config
, libinput
, systemd
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "roland";
  version = "01-02-2026-unstable";

  src = fetchFromGitHub {
    owner = "hftsai256";
    repo = "roland";
    rev = "78351b998528bd335947fb59ea3e10c331c33331";
    hash = "sha256-wQCxgd2UavxWHKY4C3dZG/pRrLxSTDRajVgsO2E9GQM=";
  };

  patches = [ (writeText "fix-test-config-path.patch" ''
    --- a/src/config.rs
    +++ b/src/config.rs
    @@ -169,7 +169,7 @@ mod tests {
         fn test_from_path() {
             let mut path = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    -        path.push("config.toml");
    +        path.push("config.example.toml");

             let config = GesturesConfig::from_path(&path).unwrap();
  '' )];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libinput
    systemd
  ];

  cargoHash = "sha256-3r80j3UXQIIxhTIKozWcqxQSSRzDH8K1ND6vFTivXD8=";

  meta = {
    homepage = "https://github.com/oknozor/roland";
    description = "A simple touch gesture recognizer for Linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
