# ./packages/python-lsp-server/default.nix
{
  setuptools,
  pylsp-mypy,
  pylsp-rope,
  python-lsp-ruff,
  python-lsp-server
}:
with builtins; let
  # WARNING: tricky stuff below:
  # We need to fix the `python-lsp-server` derivation by adding all of the (user enabled)
  # plugins to its `propagatedBuildInputs`.
  # See https://github.com/NixOS/nixpkgs/issues/229337
  removeInput = inputs: filter (pkg: pkg.pname != "python-lsp-server") inputs;

  pylsp-mypy' = pylsp-mypy.overridePythonAttrs (oldAttrs: {
    doCheck = false;
    propagatedBuildInputs = removeInput oldAttrs.propagatedBuildInputs;
    postPatch = oldAttrs.postPatch or "" + ''
      substituteInPlace setup.cfg \
        --replace-fail "python-lsp-server >=1.7.0" ""
    '';
  });

  pylsp-rope' = pylsp-rope.overridePythonAttrs (oldAttrs: {
    doCheck = false;
    propagatedBuildInputs = removeInput oldAttrs.propagatedBuildInputs;
    postPatch = oldAttrs.postPatch or "" + ''
      sed -i '/python-lsp-server/d' setup.cfg
    '';
  });

  python-lsp-ruff' = python-lsp-ruff.overridePythonAttrs (oldAttrs: {
    doCheck = false;
    propagatedBuildInputs = removeInput oldAttrs.propagatedBuildInputs;
    postPatch = oldAttrs.postPatch or "" + ''
        sed -i '/python-lsp-server/d' pyproject.toml
    '';
    build-system = [setuptools] ++ (oldAttrs.build-system or []);
  });

  thirdPartyPlugins = [pylsp-mypy' pylsp-rope' python-lsp-ruff'];

in
  python-lsp-server.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs =
      (oldAttrs.propagatedBuildInputs or [])
      ++ python-lsp-server.optional-dependencies.rope
      ++ thirdPartyPlugins;

    disabledTests =
      (oldAttrs.disabledTests or [])
      ++ [
        "test_notebook_document__did_open"
        "test_notebook_document__did_change"
      ];
  })
