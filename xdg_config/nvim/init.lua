local g, _ = vim.g, vim.fn
local o, wo, bo, opt = vim.o, vim.wo, vim.bo, vim.opt

-- Leader/local leader
g.mapleader = ","

-- Settings
o.syntax = "on"
o.autochdir = true
o.showmode = true
o.swapfile = false
o.backup = false
o.undodir = vim.fn.stdpath("config") .. "/undodir"
o.undofile = true
o.incsearch = true
o.hlsearch = true
o.hidden = true
o.completeopt = "menuone,noinsert,noselect"
o.backspace = "indent,eol,start"
o.expandtab = true
bo.autoindent = true
bo.smartindent = true
wo.relativenumber = true
wo.number=true
wo.signcolumn = "yes"
wo.cursorline = true
wo.wrap = false

-- GUI Font
opt.guifont = { "monospace:h9" }

function _G.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

-- Color Scheme
o.background = "dark"
o.termguicolors = true
g.enable_bold_font = 1
g.enable_italic_font = 1
vim.cmd([[colorscheme hybrid]])
vim.cmd([[hi Normal guibg=None ctermbg=None]])
vim.cmd([[hi LineNr guifg=#707880 ctermfg=7]])

-- lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "jellybeans",
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})

-- surrounds
require("nvim-surround").setup()

-- treesitter
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust", "python", "lua", "bash" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Load Modules
require("lsp")
require("fuzzysearch")
require("keybindings")
require("browsers")
require("utils")
