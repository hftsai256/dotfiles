{...}: {
  # Neovim ships its own GLOBAL LSP/diagnostic keymaps for free the moment
  # a server attaches (:h lsp-defaults, :h diagnostic-defaults) - most of
  # these are left alone below, they just work. VERIFIED against an actual
  # 0.11.2 install (headless keymap dump), not just the docs - the docs
  # site tracks Neovim's dev branch, which is ahead of any given release:
  #   gra  code action (n+v)   grn  rename
  #   gO   document symbols    <C-s> (insert) signature help
  #   ]d [d  next/prev diagnostic   ]D [D  last/first diagnostic
  #   <C-w>d  diagnostic at cursor, floating
  # grt (type definition) and grx (codelens) were NOT in that 0.11.2 dump -
  # they only landed as real default keymaps in 0.12.0 (see runtime/doc/news.txt
  # for that release). You're running 0.12.4, so both are live; no custom
  # leader mapping needed for either.
  # snacks.nvim's input module prettifies grn's rename prompt (vim.ui.input),
  # and snacks.picker's own ui_select integration prettifies gra's action
  # menu (vim.ui.select) - both hook in globally rather than a specific
  # keymap.
  #
  # grr and gri ARE overridden below (still on their native keys): per
  # :h vim.lsp.buf.references()/.implementation(), the native versions dump
  # results into the quickfix window at the bottom of the screen with no
  # quick way to dismiss it. Pointed at snacks.picker instead, same as
  # <leader>fr/<leader>fi - floating, fuzzy-searchable, closes on <Esc>.
  # <leader>ci/<leader>co get the same treatment for the same reason.
  #
  # telescope.nvim, nvim-tree.lua, and toggleterm.nvim were all replaced by
  # snacks.nvim modules (plugins.nix) - snacks.picker, snacks.explorer, and
  # snacks.terminal - which is why every picker/tree binding below calls
  # into a global `Snacks` table instead of `require('telescope.builtin')`.
  keymaps = [
    # File Tree & Navigation
    {
      mode = ["n"];
      key = "<leader>e";
      action = "<Cmd>lua _G.toggle_explorer()<CR>";
      # <C-e> (the old key) is native Neovim's scroll-down-one-line;
      # <leader>e for the explorer matches the common LazyVim/NvChad
      # convention and stops shadowing the built-in scroll. The toggle
      # helper itself lives in options.nix, next to peek_definition -
      # snacks.explorer only has "open", not "toggle".
      options = {silent = true; desc = "Toggle file explorer";};
    }

    # snacks.picker - everything under <leader>f, one group, one mnemonic
    {
      mode = ["n"];
      key = "<C-p>";
      action = "<Cmd>lua Snacks.picker.files({ hidden = true })<CR>";
      # Matches the ctrlp.vim/fzf convention most fuzzy-finder users already
      # have. hidden=true to keep the old find_files' --hidden behavior;
      # .git itself stays excluded, same as before, since ripgrep ignores
      # VCS directories even with hidden files shown.
      options = {silent = true; desc = "Find files";};
    }
    # <leader>fe (Telescope's file_browser extension) is gone rather than
    # ported - snacks.explorer on <leader>e now covers create/rename/move/
    # copy/delete itself, so a second "browse and edit files" picker would
    # just be the same job twice.
    {
      mode = ["n"];
      key = "<leader>fg";
      action = "<Cmd>lua Snacks.picker.grep()<CR>";
      options = {silent = true; desc = "Grep";};
    }
    {
      mode = ["n"];
      key = "<leader>fb";
      action = "<Cmd>lua Snacks.picker.buffers()<CR>";
      options = {silent = true; desc = "Buffers";};
    }
    {
      mode = ["n"];
      key = "<leader>fh";
      action = "<Cmd>lua Snacks.picker.help()<CR>";
      options = {silent = true; desc = "Help tags";};
    }
    {
      mode = ["n"];
      key = "<leader>fs";
      action = "<Cmd>lua Snacks.picker.lsp_symbols()<CR>";
      # Was bare <leader>o; native gO does the same thing with the builtin
      # picker for free, this is the fuzzy-searchable version, filed under
      # f with the rest of the picker bindings.
      options = {silent = true; desc = "Document symbols";};
    }
    {
      mode = ["n"];
      key = "<leader>fr";
      action = "<Cmd>lua Snacks.picker.lsp_references()<CR>";
      # Native grr covers the plain jump/list; this is the fuzzy-searchable version.
      options = {silent = true; desc = "LSP references";};
    }
    {
      mode = ["n"];
      key = "<leader>fi";
      action = "<Cmd>lua Snacks.picker.lsp_implementations()<CR>";
      # Native gri covers the plain jump/list; this is the fuzzy-searchable version.
      options = {silent = true; desc = "LSP implementations";};
    }
    {
      mode = ["n"];
      key = "grr";
      action = "<Cmd>lua Snacks.picker.lsp_references()<CR>";
      # Overrides the native quickfix-window version - see note above.
      options = {silent = true; desc = "LSP references (floating)";};
    }
    {
      mode = ["n"];
      key = "gri";
      action = "<Cmd>lua Snacks.picker.lsp_implementations()<CR>";
      options = {silent = true; desc = "LSP implementations (floating)";};
    }

    # General Utilities
    {
      mode = ["n"];
      key = "<leader><Space>";
      action = "<Cmd>noh<CR>";
      options = {silent = true; desc = "Clear search highlight";};
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
    # Type definition used to be bound here as <leader>ct, standing in for
    # "gt" (removed for shadowing native tab navigation). On confirmed
    # Neovim 0.12.4 the native grt already does this job, so the redundant
    # leader mapping is gone too - one fewer thing to remember.

    # Call hierarchy - snacks.picker instead of the native quickfix-window versions.
    {
      mode = ["n"];
      key = "<leader>ci";
      action = "<Cmd>lua Snacks.picker.lsp_incoming_calls()<CR>";
      options = {desc = "Incoming calls";};
    }
    {
      mode = ["n"];
      key = "<leader>co";
      action = "<Cmd>lua Snacks.picker.lsp_outgoing_calls()<CR>";
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
