local actions = require('telescope.actions')
local keymap = vim.api.nvim_set_keymap

require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    prompt_prefix = ' >',
    color_devicons = true,

    file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    mappings = {
      i = {
        ["<C-x>"] = false,
        ["<C-q>"] = actions.send_to_qflist,
      },
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

require('telescope').load_extension('fzy_native')

-- Keybindings
opt = {noremap=true, silent=true}
keymap('n', '<C-p>', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
keymap('n', '<Leader>fg', [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], opt)
keymap('n', '<Leader>fb', [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], opt)
keymap('n', '<Leader>fh', [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], opt)

