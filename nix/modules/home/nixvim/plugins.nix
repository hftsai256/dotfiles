{pkgs, ...}: {
  extraPackages = with pkgs; [
    alejandra
  ];

  autoCmd = [
    {
      event = ["FileType"];
      pattern = ["rust"];
      callback.__raw = ''
        function(args)
          vim.treesitter.stop(args.buf)
        end
      '';
    }
  ];

  plugins = {
    # LSP & Language Configuration
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        ts_ls.enable = true;
        clangd.enable = true;
        html.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        svelte.enable = true;

        nil_ls = {
          enable = true;
          settings = {
            nix.flake.autoArchive = false;
            formatting.command = ["alejandra"];
          };
        };

        pylsp = {
          enable = true;
          settings.plugins = {
            jedi_completion.enabled = true;
            jedi_hover.enabled = true;
            jedi_references.enabled = true;
            jedi_signature_help.enabled = true;
            jedi_symbols.enabled = true;
            pylsp_mypy.enabled = true;
            pylsp_mypy.live_mode = false;
            black.enabled = true;
            ruff.enabled = true;
            isort.enabled = true;
            rope_autoimport.enabled = true;
            rope_completion.enabled = true;
          };
        };

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
          settings = {
            cargo.allFeatures = true;
            procMacro.enable = true;
          };
        };

        ltex = {
          enable = true;
          filetypes = ["tex" "md" "txt"];
          settings.ltex.language = "en-US";
        };
      };
    };

    # Autocompletion & Snippets
    lspkind.enable = true;
    luasnip.enable = true;
    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
        snippet = {expand = "luasnip";};
        formatting = {fields = ["kind" "abbr" "menu"];};
        sources = [
          {name = "git";}
          {name = "nvim_lsp";}
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path";
            keywordLength = 3;
          }
          {
            name = "luasnip";
            keywordLength = 3;
          }
        ];

        mapping = {
          "<ESC>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                if luasnip.expandable() then
                  luasnip.expand()
                else
                  cmp.confirm({
                    select = true,
                  })
                end
              else
                fallback()
              end
            end)
          '';

          "<Up>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<Down>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };
      };
    };

    # Git Integration
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {text = " ";};
          change = {text = " ";};
          delete = {text = " ";};
          untracked = {text = "";};
          topdelete = {text = "󱂥 ";};
          changedelete = {text = "󱂧 ";};
        };
      };
    };
    lazygit.enable = true;
    gitblame.enable = true;

    # UI & Tools
    telescope = {
      enable = true;
      extensions = {
        file-browser.enable = true;
        fzf-native.enable = true;
      };
    };

    nvim-tree = {
      enable = true;
      settings = {
        update_focused_file = {
          enable = true;
          update_root = true;
        };
        renderer.group_empty = true;
      };
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

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }
  ];

  extraConfigLua = ''
    luasnip = require("luasnip")
    kind_icons = {
      Text = "󰊄",
      Method = " ",
      Function = "󰡱 ",
      Constructor = " ",
      Field = " ",
      Variable = "󱀍 ",
      Class = " ",
      Interface = " ",
      Module = "󰕳 ",
      Property = " ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = "",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    }

    local cmp = require'cmp'

    cmp.setup.cmdline({'/', "?" }, {
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' },
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
    })
  '';
}
