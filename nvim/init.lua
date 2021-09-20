local g, fn = vim.g, vim.fn
local o, wo, bo = vim.o, vim.wo, vim.bo
local utils = require('utils')

-- Leader/local leader
g.mapleader = ','

-- Settings
o.syntax = 'on'
o.showmode = true
o.swapfile = false
o.backup = false
o.undodir = vim.fn.stdpath('config') .. '/undodir'
o.undofile = true
o.incsearch = true
o.hlsearch = true
o.hidden = true
o.completeopt = 'menuone,noinsert,noselect'
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.backspace = 'indent,eol,start'
o.expandtab = true
bo.autoindent = true
bo.smartindent = true
wo.number = true
wo.signcolumn = 'yes'
wo.cursorline = true
wo.wrap = false

-- Colorscheme
o.termguicolors = true
o.background = 'dark'
vim.cmd('colorscheme hybrid')

-- Airline
g.airline_theme = 'hybridline'
g.airline_powerline_fonts = 1
g['airline#extensions#tabline#enabled'] = 1
g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'

-- Load Modules
require('plugin')
require('lsp')
require('fuzzysearch')
require('keybindings')
require('diff')

function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

