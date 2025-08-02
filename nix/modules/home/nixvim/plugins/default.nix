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
        html.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        svelte.enable = true;

        pylsp = {
          enable = true;
          settings.plugins = {
            jedi_completion.enabled = true;
            jedi_hover.enabled = true;
            jedi_references.enabled = true;
            jedi_signature_help.enabled = true;
            jedi_symbols.enabled = true;

            # Type checking
            pylsp_mypy.enabled = true;
            pylsp_mypy.live_mode = false;

            # Formatting
            black.enabled = true;

            # Linting
            ruff.enabled = true;

            # Import sorting
            isort.enabled = true;

            # Refactoring
            rope_autoimport.enabled = true;
            rope_completion.enabled = true;
          };
        };

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
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

    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          disable = [ "rust" ];
        };
        indent.enable = true;
      };
    };

    nvim-tree = {
      enable = true;
      updateFocusedFile = {
        enable = true;
        updateRoot = true;
      };
      renderer.groupEmpty = true;
    };

    vimtex = {
      enable = true;
      texlivePackage = null;
      settings.view_method = "zathura";
      settings.compiler_method = "tectonic";
    };

    web-devicons.enable = true;
    lualine.enable = true;
    indent-o-matic.enable = true;
    indent-blankline.enable = true;
    ts-autotag.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    which-key.enable = true;
  };

  extraConfigLua = ''
    local sysroot = vim.fn.systemlist("rustc --print sysroot")[1]
    require('lspconfig').rust_analyzer.setup({
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            sysroot = sysroot,
          },
        },
      },
    })
  '';
}
