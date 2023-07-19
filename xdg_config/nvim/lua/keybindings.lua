local keymap = vim.api.nvim_set_keymap
local utils = require("utils")
local exec = utils.exec

-- Abbreviations
exec.abbrev("<leader>b", "import pdb; pdb.set_trace()")
exec.abbrev("#i", "#include")
exec.abbrev("#d", "#define")

-- User Keybindings
local opt = { noremap = true, silent = true }
keymap("n", "<leader><Space>", [[<Cmd>nohlsearch<CR>]], opt)

