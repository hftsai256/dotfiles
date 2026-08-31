{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  nvimRepo = "${homeDirectory}/.dotfiles/xdg_config/nvim";

  pylsp = pkgs.python3.withPackages (ps:
    [
      ps.python-lsp-server
      ps.pylsp-mypy
      ps.pylsp-rope
      ps.python-lsp-ruff
      ps.python-lsp-black
    ]
    ++ (ps.python-lsp-server.optional-dependencies.rope or []));
in {
  xdg.configFile."nvim".source = lib.mkForce (mkOutOfStoreSymlink "${nvimRepo}");

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      git
      gcc
      gnumake

      alejandra
      trash-cli
      ghostscript
      mermaid-cli
      tectonic
      zathura
      python3Packages.pylatexenc

      lua-language-server
      typescript-language-server
      vscode-langservers-extracted
      svelte-language-server
      clang-tools
      nil
      ltex-ls
      rust-analyzer

      pylsp
      black
      ruff
      isort
      mypy
    ];
  };

  programs.lazygit.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
