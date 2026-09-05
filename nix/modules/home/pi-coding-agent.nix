{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  cfg = config.programs.pi-coding-agent;

  jsonFormat = pkgs.formats.json { };

  upstreamConfigDir = "${config.home.homeDirectory}/.pi/agent";
  npmPrefix = "${config.home.homeDirectory}/.pi/npm";

  extraPkgNamed =
    names: lib.findFirst (p: lib.elem (lib.getName p) names) null cfg.extraPackages;

  pandocPkg = extraPkgNamed [ "pandoc" ];
  chromiumPkg = extraPkgNamed [
    "chromium"
    "ungoogled-chromium"
    "google-chrome"
    "brave"
  ];

  wrapArgs =
    lib.optionalString (cfg.extraPackages != [ ])
      "--suffix PATH : ${lib.makeBinPath cfg.extraPackages} "
    + lib.optionalString (pandocPkg != null)
      "--set PANDOC_PATH ${lib.escapeShellArg (lib.getExe pandocPkg)} "
    + lib.optionalString (chromiumPkg != null)
      "--set PUPPETEER_EXECUTABLE_PATH ${lib.escapeShellArg (lib.getExe chromiumPkg)} "
    + lib.optionalString cfg.wrapNpm ''
      --set NPM_CONFIG_PREFIX ${lib.escapeShellArg npmPrefix} \
      --prefix PATH : ${lib.makeBinPath [ cfg.nodejs ]}
    '';

  wrappedPackage =
    if cfg.package == null then
      null
    else if wrapArgs == "" then
      cfg.package
    else
      pkgs.symlinkJoin {
        inherit (cfg.package) meta;
        name = "${lib.getName cfg.package}-wrapped-${lib.getVersion cfg.package}";
        paths = [ cfg.package ];
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/pi \
            ${wrapArgs}
        '';
      };

  contextIsPath = builtins.isPath cfg.context;

  # settings.json is mutated by `pi` (theme, lastChangelogVersion, packages, …).
  # Never replace it with a store symlink: that clobbers the live file and
  # `pi list` only reads packages from that JSON.
  settingsPackages = cfg.settings.packages or [ ];
  settingsRest = builtins.removeAttrs cfg.settings [ "packages" ];

  packageSource =
    pkg:
    if builtins.isString pkg then
      pkg
    else if builtins.isAttrs pkg && pkg ? source then
      pkg.source
    else
      throw "programs.pi-coding-agent.settings.packages entries must be a string or `{ source = ...; }`";

  declaredPackageSources = map packageSource settingsPackages;

  settingsRestFile = jsonFormat.generate "pi-coding-agent-settings-fragment.json" settingsRest;

  jq = lib.getExe pkgs.jq;
  piBin = lib.optionalString (wrappedPackage != null) "${wrappedPackage}/bin/pi";
in
{
  options.programs.pi-coding-agent = {
    enable = mkEnableOption "pi-coding-agent";

    package = mkPackageOption pkgs "pi-coding-agent" { nullable = true; };

    nodejs = mkPackageOption pkgs "nodejs" { };

    wrapNpm = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Wrap pi with NPM_CONFIG_PREFIX=$HOME/.pi/npm and put nodejs on PATH
        so `pi install npm:...` does not write into the nix store.
      '';
    };

    extraPackages = mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = literalExpression "[ pkgs.pandoc pkgs.chromium ]";
      description = ''
        Extra packages added to the wrapped pi PATH.
        nodejs is already added when wrapNpm is true.

        Terminal `/preview` (Kitty images) needs pandoc plus a Chromium
        browser. Chromium is not looked up on PATH — if chromium,
        ungoogled-chromium, google-chrome, or brave is listed here, the
        wrapper sets PUPPETEER_EXECUTABLE_PATH. Pandoc sets PANDOC_PATH.
      '';
    };

    configDir = mkOption {
      type = lib.types.str;
      default = upstreamConfigDir;
      defaultText = literalExpression ''"''${config.home.homeDirectory}/.pi/agent"'';
      example = literalExpression ''"''${config.xdg.configHome}/pi/agent"'';
      description = ''
        Directory holding Pi Coding Agent configuration files.
        PI_CODING_AGENT_DIR is set when this differs from ~/.pi/agent.
      '';
    };

    settings = mkOption {
      inherit (jsonFormat) type;
      default = { };
      example = {
        packages = [ "npm:pi-markdown-preview" ];
      };
      description = ''
        Merged into settings.json in configDir on activation.
        `packages` are installed with `pi install` (needed for `pi list`
        and for the actual npm/git checkout under ~/.pi/agent/npm).
        Other keys are merged into the existing file so pi can keep
        mutating lastChangelogVersion, theme, default model, etc.

        See https://pi.dev/docs/latest/settings
      '';
    };

    keybindings = mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = ''
        Written to keybindings.json in configDir.
        See https://pi.dev/docs/latest/keybindings
      '';
    };

    models = mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = ''
        Written to models.json in configDir.
        See https://pi.dev/docs/latest/models
      '';
    };

    context = mkOption {
      type = lib.types.either lib.types.lines lib.types.path;
      default = "";
      example = literalExpression "./pi-context.md";
      description = ''
        Global context written to AGENTS.md in configDir.
        A path copies that file; a string writes the text.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (wrappedPackage != null) [ wrappedPackage ];

    home.sessionVariables = lib.mkIf (cfg.configDir != upstreamConfigDir) {
      PI_CODING_AGENT_DIR = cfg.configDir;
    };

    home.file = lib.mkMerge [
      (mkIf (cfg.keybindings != { }) {
        "${cfg.configDir}/keybindings.json".source =
          jsonFormat.generate "pi-coding-agent-keybindings.json" cfg.keybindings;
      })
      (mkIf (cfg.models != { }) {
        "${cfg.configDir}/models.json".source =
          jsonFormat.generate "pi-coding-agent-models.json" cfg.models;
      })
      (
        if contextIsPath then
          { "${cfg.configDir}/AGENTS.md".source = cfg.context; }
        else
          (mkIf (cfg.context != "") {
            "${cfg.configDir}/AGENTS.md".text = cfg.context;
          })
      )
    ];

    home.activation.piCodingAgentSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        settingsFile = cfg.configDir + "/settings.json";
        mergeSettings =
          lib.optionalString (settingsRest != { }) ''
            fragment=${lib.escapeShellArg settingsRestFile}
            if [ -f "$settingsFile" ]; then
              if [ -L "$settingsFile" ]; then
                cp --remove-destination "$(readlink -f "$settingsFile")" "$settingsFile.tmp"
                mv "$settingsFile.tmp" "$settingsFile"
                chmod u+w "$settingsFile"
              fi
              ${jq} -s '.[0] * .[1]' "$settingsFile" "$fragment" > "$settingsFile.tmp"
              mv "$settingsFile.tmp" "$settingsFile"
            else
              cp "$fragment" "$settingsFile"
              chmod u+w "$settingsFile"
            fi
          '';

        installOne =
          src:
          lib.optionalString (piBin != "") ''
            if ! piHasPackage ${lib.escapeShellArg src}; then
              echo "Installing pi package ${src}"
              ${piBin} install ${lib.escapeShellArg src}
            fi
          '';
      in
      ''
        settingsFile=${lib.escapeShellArg settingsFile}
        mkdir -p ${lib.escapeShellArg cfg.configDir}
        ${mergeSettings}

        piHasPackage() {
          local src="$1"
          if [ ! -f "$settingsFile" ]; then
            return 1
          fi
          ${jq} -e --arg src "$src" \
            '(.packages // []) | map(if type == "string" then . else .source end) | index($src) != null' \
            "$settingsFile" >/dev/null
        }

        ${lib.concatMapStrings installOne declaredPackageSources}
      ''
    );
  };
}
