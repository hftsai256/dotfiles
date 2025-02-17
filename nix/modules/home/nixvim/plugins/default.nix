{ pkgs, ... }: {
  imports = [
    ./cmp.nix
    ./git.nix
  ];

  plugins = {
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        ts_ls.enable = true;
        nixd.enable = true;
        clangd.enable = true;

        pylsp = {
          enable = true;
          settings.plugins = {
            autopep8.enabled = false;
            ruff.enabled = true;
          };
        };

        rust_analyzer = with pkgs.rust-bin.stable.latest; {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
          package = rust-analyzer;
        };
      };
    };

    lspsaga = {
      enable = true;
      beacon.enable = true;
    };

    telescope = {
      enable = true;
      extensions = {
        file-browser.enable = true;
        fzf-native.enable = true;
      };
    };

    treesitter.enable = true;
    web-devicons.enable = true;
    lualine.enable = true;

    nvim-tree = {
      enable = true;
      updateFocusedFile = {
        enable = true;
        updateRoot = true;
      };
      renderer.groupEmpty = true;
    };

    indent-o-matic.enable = true;
    indent-blankline.enable = true;
    nvim-surround.enable = true;
    which-key.enable = true;
  };
}
