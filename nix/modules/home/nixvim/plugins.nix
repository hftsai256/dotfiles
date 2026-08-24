{pkgs, ...}: {
  extraPackages = with pkgs; [
    alejandra
    trash-cli
    ghostscript
    mermaid-cli

    tectonic
    python3Packages.pylatexenc # `latex2text`
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
    # dressing.nvim (the old floating UI for vim.ui.input/vim.ui.select) was
    # archived by its maintainer on 2025-02-12: every fuzzy picker now ships
    # its own vim.ui.select, and vim.ui.input has better standalone options,
    # so a dedicated wrapper plugin stopped earning its keep. Split its two
    # jobs the way the maintainer himself pointed to:
    #   - vim.ui.input (grn's rename prompt)  -> snacks.nvim's input module
    #   - vim.ui.select (gra's action menu)   -> snacks.picker's own
    #     ui_select integration (on by default - see picker below), now
    #     that snacks.picker is the installed picker instead of Telescope
    snacks = {
      enable = true;
      settings = {
        # Skips the full startup pipeline (syntax highlighting, matchparen,
        # etc.) for files over the size/line threshold, so opening a huge
        # log or minified file doesn't hang the UI.
        bigfile = {
          enabled = true;
          notify = true;
        };

        # Inline image rendering for terminals that support a graphics
        # protocol (kitty graphics protocol - the default per term.nix).
        image = {
          enabled = true;
          doc = {
            inline = false;
            float = true;
            max_width = 160;
          };
          math = {
            enabled = true;
            latex.font_size = "normalsize";
          };
        };

        input = {
          enabled = true;
          border = "single";
          relative = "cursor"; # Opens the rename box directly at your cursor, same as before
        };

        # Replaces kdheepak/lazygit.nvim: same LazyGit-in-a-float idea, but
        # snacks auto-matches your colorscheme for LazyGit's own theme and
        # takes a real border option instead of the vim.g hack that used to
        # live at the bottom of this file.
        lazygit = {
          enabled = true;
          win.border = "single";
        };

        # Replaces lukas-reineke/indent-blankline.nvim - same vertical
        # guide-line idea, plus scope highlighting derived from treesitter
        # (which is already enabled below) instead of pure indentation
        # counting.
        indent = {
          enabled = true;
        };

        # Replaces telescope.nvim (+ its file-browser, fzf-native, and
        # ui-select extensions) for every fuzzy-find/grep/LSP-list job
        # below - one plugin instead of four. ui_select is a snacks
        # default (true), listed here so it's not a silent implicit
        # behavior. fzf-native doesn't have a direct snacks equivalent to
        # configure; the picker's own matcher is native Lua, no external
        # dependency to reconfigure.
        picker = {
          enabled = true;
          ui_select = true;
        };

        # Replaces nvim-tree.lua. Despite "picker" in the name, the
        # explorer's own default layout is "sidebar" (fixed-width, left
        # side, no auto-close on opening a file) - it behaves like a
        # persistent tree, it's just built on the picker engine, so it
        # gets fuzzy grep/search for free. See keymaps.nix for the
        # <leader>e toggle helper - the explorer itself has no toggle,
        # only open.
        explorer = {
          enabled = true;
          replace_netrw = true;
          trash = true;
        };

        # Replaces toggleterm.nvim. Without an explicit cmd, snacks opens
        # terminals as a bottom split by default - forced back to a
        # float here to match toggleterm's old float_opts and everything
        # else in this config. One capability doesn't carry over: there's
        # no documented [[ / ]] shell-prompt jump like toggleterm had.
        terminal = {
          enabled = true;
          win = {
            position = "float";
            border = "single";
          };
        };

        # Start screen shown when opening nvim with no file arguments. Its
        # preset action keys (f/n/g/r/c/s/L/q) are buffer-local to the
        # dashboard itself - nothing extra to bind here.
        #
        # sections is overridden to drop the default list's third entry,
        # { section = "startup" } - that section unconditionally calls
        # require("lazy.stats") to report plugin count/load time in the
        # footer, a hard dependency on lazy.nvim as the plugin manager.
        # This config installs plugins declaratively via Nix instead, so
        # that module doesn't exist and it crashes on every UIEnter.
        # There's no config flag to disable just that piece (checked the
        # plugin source directly) - keeping header + keys and dropping
        # startup is the only documented way around it.
        dashboard = {
          enabled = true;
          sections = [
            {section = "header";}
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
          ];
        };

        # Replaces vim.notify with a floating, styled notification popup.
        # No other notify plugin is installed, so there's nothing else to
        # disable in favor of this.
        notifier = {
          enabled = true;
        };

        # Renders whatever file is passed on the command line (nvim
        # somefile) immediately, before plugins finish loading, instead of
        # waiting on the full startup pipeline.
        quickfile = {
          enabled = true;
        };

        # Treesitter-based scope detection - also wires its own
        # textobjects/jumps the moment it's enabled: ii/ai (inner/around
        # scope) and [i/]i (jump to scope start/end). Nothing here
        # collides with existing bindings.
        scope = {
          enabled = true;
        };

        # Animated smooth scrolling for <C-d>/<C-u>/gg/G/search jumps and
        # the like.
        scroll = {
          enabled = true;
        };

        # Custom statuscolumn: draws the sign column (gitsigns hunks and
        # diagnostic signs), line numbers, and fold column as one unit
        # instead of Neovim's native separate rendering. Reads gitsigns'
        # highlight groups by name automatically, so nothing in the
        # gitsigns block above needs to change for the two to work
        # together.
        statuscolumn = {
          enabled = true;
        };

        # Auto-highlights other references to the word under the cursor
        # (LSP-powered, like vim-illuminate). The module only sets up the
        # highlighting - jumping between references (]]/[[, below in
        # keymaps.nix) isn't bound by snacks itself.
        words = {
          enabled = true;
        };
      };
    };

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
        window = {
          completion = {border = "single";};
          documentation = {border = "single";};
        };
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
    # gitblame.nvim stays: its persistent inline virtual-text blame on the
    # current line isn't something snacks.git replicates - Snacks.git.blame_line()
    # is an on-demand popup (git log for the line), a different feature, not
    # a drop-in swap.
    gitblame.enable = true;

    # UI & Tools
    vimtex = {
      enable = true;
      texlivePackage = null;
      settings.view_method = "zathura";
      settings.compiler_method = "tectonic";
    };

    # In-buffer markdown rendering: headers, code fences, tables, and
    # checkboxes get drawn with extmarks instead of shown as raw syntax.
    # Markdown only (its default file_types) - it doesn't touch .tex
    # buffers, and wouldn't render one correctly if it did (it's reading
    # markdown/markdown_inline treesitter syntax, not LaTeX's). "latex"
    # here is its own narrower feature: rendering LaTeX math *inside*
    # markdown files (inline $..$ and block $$..$$) as unicode - separate
    # from vimtex, which still owns actual .tex documents.
    render-markdown = {
      enable = true;
      settings.latex.enabled = false;
    };

    web-devicons.enable = true;
    lualine.enable = true;
    indent-o-matic.enable = true;

    # Parser install only, no highlight module: your LSP servers already
    # provide semantic-token highlighting for every filetype you use, so
    # treesitter's highlighting would be redundant. Indent stays on since
    # nothing else here gives real-time smart indent while typing, and
    # ts-autotag (needs an active parser per buffer - the source of the
    # "needs treesitter to function as intended" warning) keeps working
    # because indent.enable alone still attaches a parser to the buffer.
    treesitter = {
      enable = true;
      indent.enable = true;
    };
    ts-autotag.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    which-key = {
      enable = true;
      settings.win.border = "single"; # defaults to "none" - was the 4th odd-one-out
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>lua Snacks.lazygit()<CR>";
      # Was the standalone lazygit.nvim plugin's :LazyGit command - snacks
      # exposes itself as a global _G.Snacks table once loaded, so this is
      # just a function call rather than an Ex command now.
      options = {
        desc = "LazyGit (root dir)";
      };
    }
    {
      # Used to come for free from toggleterm's own open_mapping option;
      # snacks.terminal doesn't create its own keymap, so this replaces it
      # directly. Bound in both modes since <Cmd>lua...<CR> works fine from
      # terminal mode too (:h <Cmd>) - same close-from-inside behavior the
      # old open_mapping gave for free.
      mode = ["n" "t"];
      key = "<A-t>";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options = {
        desc = "Toggle floating terminal";
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
