{
  lib,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  coreutils,
  psmisc,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "decky-loader";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "SteamDeckHomebrew";
    repo = "decky-loader";
    rev = "v${version}";
    hash = "sha256-p1bkLsZedTZ29POqdaXvVpPXzg9kBTKgUxkkEAyAkT0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/frontend";
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-WgKycKbaZv9lovoo0IaCuV41qS4zUqm4vZxsMQBUdNk=";
    # v3.2.6 added frontend/pnpm-workspace.yaml solely to set
    # `minimumReleaseAgeExclude`; it has no `packages` field, which makes
    # pnpm treat the dir as a malformed workspace root and fail install
    # with "packages field missing or empty". Drop it before pnpm runs;
    # nix already pins/verifies every dep via the lockfile hash, so the
    # minimumReleaseAge supply-chain check this file configures isn't
    # needed for a frozen-lockfile fetch anyway.
    postPatch = ''
      rm -f pnpm-workspace.yaml
    '';
  };

  pyproject = true;
  pnpmRoot = "frontend";

  nativeBuildInputs = [nodejs pnpm_9 pnpmConfigHook];

  # Same pnpm-workspace.yaml issue as pnpmDeps above (this derivation
  # re-runs pnpm install via pnpmConfigHook, against a fresh unpatched
  # copy of src, so it needs the file removed here too).
  postPatch = ''
    rm -f frontend/pnpm-workspace.yaml
  '';

  preBuild = ''
    cd frontend
    pnpm build
    cd ../backend
  '';

  build-system = with python3.pkgs; [poetry-core poetry-dynamic-versioning];

  dependencies = with python3.pkgs; [
    aiohttp
    aiohttp-cors
    aiohttp-jinja2
    certifi
    multidict
    packaging
    setproctitle
    watchdog
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [coreutils psmisc]}"
  ];

  pythonRelaxDeps = ["aiohttp-cors" "packaging" "watchdog"];

  passthru.python = python3;

  meta = with lib; {
    description = "A plugin loader for the Steam Deck";
    homepage = "https://github.com/SteamDeckHomebrew/decky-loader";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
