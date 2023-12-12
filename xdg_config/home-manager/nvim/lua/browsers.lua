local g = vim.g
local keymap = vim.api.nvim_set_keymap

-- Disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

require("project_nvim").setup()

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
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

