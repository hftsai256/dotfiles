-- Neovim ships its own GLOBAL LSP/diagnostic keymaps for free the moment
-- a server attaches (:h lsp-defaults, :h diagnostic-defaults) - most of
-- these are left alone below, they just work. VERIFIED against an actual
-- 0.11.2 install (headless keymap dump), not just the docs - the docs
-- site tracks Neovim's dev branch, which is ahead of any given release:
--   gra  code action (n+v)   grn  rename
--   gO   document symbols    <C-s> (insert) signature help
--   ]d [d  next/prev diagnostic   ]D [D  last/first diagnostic
--   <C-w>d  diagnostic at cursor, floating
-- grt (type definition) and grx (codelens) were NOT in that 0.11.2 dump -
-- they only landed as real default keymaps in 0.12.0 (see runtime/doc/news.txt
-- for that release). You're running 0.12, so both are live; no custom
-- leader mapping needed for either.
-- snacks.nvim's input module prettifies grn's rename prompt (vim.ui.input),
-- and snacks.picker's own ui_select integration prettifies gra's action
-- menu (vim.ui.select) - both hook in globally rather than a specific
-- keymap.
--
-- grr and gri ARE overridden below (still on their native keys): per
-- :h vim.lsp.buf.references()/.implementation(), the native versions dump
-- results into the quickfix window at the bottom of the screen with no
-- quick way to dismiss it. Pointed at snacks.picker instead, same as
-- <leader>fr/<leader>fi - floating, fuzzy-searchable, closes on <Esc>.
-- <leader>ci/<leader>co get the same treatment for the same reason.
--
-- telescope.nvim, nvim-tree.lua, and toggleterm.nvim were all replaced by
-- snacks.nvim modules - snacks.picker, snacks.explorer, and
-- snacks.terminal - which is why every picker/tree binding below calls
-- into a global `Snacks` table instead of `require('telescope.builtin')`.

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>e", function()
  _G.toggle_explorer()
end, { desc = "Toggle file explorer" })

map("n", "<C-p>", function()
  Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })

map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help tags" })

map("n", "<leader>fs", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Document symbols" })

map("n", "<leader>fr", function()
  Snacks.picker.lsp_references()
end, { desc = "LSP references" })

map("n", "<leader>fi", function()
  Snacks.picker.lsp_implementations()
end, { desc = "LSP implementations" })

map("n", "grr", function()
  Snacks.picker.lsp_references()
end, { desc = "LSP references (floating)" })

map("n", "gri", function()
  Snacks.picker.lsp_implementations()
end, { desc = "LSP implementations (floating)" })

map("n", "<leader><Space>", "<Cmd>noh<CR>", { desc = "Clear search highlight" })

map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Jump to definition" })

map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "Go to declaration" })

map("n", "<leader>cp", function()
  _G.peek_definition()
end, { desc = "Peek definition" })

map("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Hover documentation" })

map("n", "<leader>ci", function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = "Incoming calls" })

map("n", "<leader>co", function()
  Snacks.picker.lsp_outgoing_calls()
end, { desc = "Outgoing calls" })

map("n", "<leader>cf", function()
  vim.lsp.buf.format()
end, { desc = "Format buffer" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic (float)" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic (float)" })

map("n", "[E", function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Previous error" })

map("n", "]E", function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Next error" })

map("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "LazyGit (root dir)" })

map({ "n", "t" }, "<A-t>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle floating terminal" })

require("nvim-tmux-navigation").setup({
  disable_when_zoomed = true,
  keybindings = {
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
    last_active = "<C-\\>",
  },
})
