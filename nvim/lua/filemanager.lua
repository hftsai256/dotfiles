local keymap = vim.api.nvim_set_keymap
g["fern#disable_drawer_auto_quit"] = 1
g["fern#default_hidden"] = 1
g["drawer_width"] = 1

-- Keybindings
opt = { noremap = true, silent = true }
keymap("n", "<C-p>", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
keymap("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], opt)
keymap("n", "<Leader>fb", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], opt)
keymap("n", "<Leader>fh", [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], opt)
