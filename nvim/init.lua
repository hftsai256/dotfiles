local g, fn = vim.g, vim.fn
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
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.backspace = "indent,eol,start"
o.expandtab = true
o.background = "dark"
bo.autoindent = true
bo.smartindent = true
wo.number = true
wo.signcolumn = "yes"
wo.cursorline = true
wo.wrap = false

-- GUI Font
opt.guifont = { "Fira Code Regular Nerd Font Complete:h12" }

-- Load Modules
require("plugin")
require("lsp")
require("fuzzysearch")
require("keybindings")
require("filemanager")

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
vim.cmd([[colorscheme hybrid]])
-- require('hybrid').setup()

-- Lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "Tomorrow",
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
