local g = vim.g
local keymap = vim.api.nvim_set_keymap

-- Disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
})

-- Keybindings
local opt = { noremap = true, silent = true }
keymap("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", opt)

