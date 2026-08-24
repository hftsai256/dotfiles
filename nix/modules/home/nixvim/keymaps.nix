{...}: {
  # Neovim 0.11+ ships its own GLOBAL LSP/diagnostic keymaps for free the
  # moment a server attaches (:h lsp-defaults, :h diagnostic-defaults) -
  # none of these are redefined below, they just work:
  #   gra  code action (n+v)   gri  implementation      grn  rename
  #   grr  references          grt  type definition     grx  codelens.run
  #   gO   document symbols    <C-s> (insert) signature help
  #   ]d [d  next/prev diagnostic   ]D [D  last/first diagnostic
  #   <C-w>d  diagnostic at cursor, floating
  # dressing.nvim still prettifies grn's rename prompt and gra's action
  # menu automatically, since it hooks vim.ui.input/vim.ui.select globally
  # rather than a specific keymap.
  keymaps = [
    # File Tree & Navigation
    {
      mode = ["n"];
      key = "<leader>e";
      action = "<Cmd>NvimTreeToggle<CR>";
      # <C-e> (the old key) is native Neovim's scroll-down-one-line;
      # <leader>e for the explorer matches the common LazyVim/NvChad
      # convention and stops shadowing the built-in scroll.
      options = {
        silent = true;
        desc = "Toggle file explorer";
      };
    }

    # Telescope - everything under <leader>f, one group, one mnemonic
    {
      mode = ["n"];
      key = "<C-p>";
      action = "<Cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>";
      # Matches the ctrlp.vim/fzf convention most fuzzy-finder users already have.
      options = {
        silent = true;
        desc = "Find files";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fe";
      action = "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>";
      # Was bare <leader>b, which read like a "buffers" binding (that's
      # <leader>fb below) and sat outside the f-group its siblings live in.
      options = {
        silent = true;
        desc = "File browser";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fg";
      action = "<Cmd>lua require('telescope.builtin').live_grep()<CR>";
      options = {
        silent = true;
        desc = "Live grep";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fb";
      action = "<Cmd>lua require('telescope.builtin').buffers()<CR>";
      options = {
        silent = true;
        desc = "Buffers";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fh";
      action = "<Cmd>lua require('telescope.builtin').help_tags()<CR>";
      options = {
        silent = true;
        desc = "Help tags";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fs";
      action = "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
      # Was bare <leader>o; native gO does the same thing with the builtin
      # picker for free, this is the fuzzy-searchable version, filed under
      # f with the rest of the telescope pickers.
      options = {
        silent = true;
        desc = "Document symbols";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fr";
      action = "<Cmd>lua require('telescope.builtin').lsp_references()<CR>";
      # Native grr covers the plain jump/list; this is the fuzzy-searchable version.
      options = {
        silent = true;
        desc = "LSP references";
      };
    }
    {
      mode = ["n"];
      key = "<leader>fi";
      action = "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>";
      # Native gri covers the plain jump/list; this is the fuzzy-searchable version.
      options = {
        silent = true;
        desc = "LSP implementations";
      };
    }

    # General Utilities
    {
      mode = ["n"];
      key = "<leader><Space>";
      action = "<Cmd>noh<CR>";
      options = {
        silent = true;
        desc = "Clear search highlight";
      };
    }

    # LSP: definition/declaration restored to their conventional keys.
    # gD used to be bound to jump-to-definition and gd to a custom peek -
    # backwards from every nvim-lspconfig-descended config (gd = definition,
    # gD = declaration), so gD is fixed here and peek moves off gd entirely.
    {
      mode = ["n"];
      key = "gd";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
      options = {desc = "Jump to definition";};
    }
    {
      mode = ["n"];
      key = "gD";
      action = "<Cmd>lua vim.lsp.buf.declaration()<CR>";
      # Previously unbound entirely.
      options = {desc = "Go to declaration";};
    }
    {
      mode = ["n"];
      key = "<leader>cp";
      action = "<Cmd>lua _G.peek_definition()<CR>";
      # The custom peek function (options.nix) - moved here since gd is
      # spoken for. Grouped with the other custom LSP extras below.
      options = {desc = "Peek definition";};
    }
    {
      mode = ["n"];
      key = "K";
      action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
      options = {desc = "Hover documentation";};
    }

    # LSP extras with no native equivalent - kept as-is.
    {
      mode = ["n"];
      key = "<leader>ci";
      action = "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>";
      options = {desc = "Incoming calls";};
    }
    {
      mode = ["n"];
      key = "<leader>co";
      action = "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>";
      options = {desc = "Outgoing calls";};
    }
    {
      mode = ["n"];
      key = "<leader>cf";
      action = "<Cmd>lua vim.lsp.buf.format()<CR>";
      # Was bare "ff", which shadowed the native f{char} find-in-line motion
      # and was the only binding in this file not under <leader>.
      options = {desc = "Format buffer";};
    }

    # Diagnostics: the plain jumps (]d [d, first/last ]D [D) are native and
    # left untouched. Overriding ]d/[d here only to add float=true, since
    # virtual_text is off (options.nix) and a bare jump would otherwise
    # leave you without any visible message. Same keys Neovim already
    # binds, just with the one behavior this config actually wants added.
    {
      mode = ["n"];
      key = "[d";
      action = "<Cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>";
      options = {desc = "Previous diagnostic (float)";};
    }
    {
      mode = ["n"];
      key = "]d";
      action = "<Cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
      options = {desc = "Next diagnostic (float)";};
    }
    {
      mode = ["n"];
      key = "[E";
      action = "<Cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
      # No native equivalent (]D/[D are first/last, not severity-filtered).
      options = {desc = "Previous error";};
    }
    {
      mode = ["n"];
      key = "]E";
      action = "<Cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
      options = {desc = "Next error";};
    }
  ];
}
