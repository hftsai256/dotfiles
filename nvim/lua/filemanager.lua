local g = vim.g
local keymap = vim.api.nvim_set_keymap

g["fern#disable_drawer_auto_quit"] = 1
g["fern#default_hidden"] = 1
g["drawer_width"] = 20

-- Keybindings
opt = { noremap = true, silent = true }
keymap("n", "<C-e>", "<cmd>Fern . -drawer -toggle<CR>", opt)

