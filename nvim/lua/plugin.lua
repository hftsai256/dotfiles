local vim = vim
local exec = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    exec('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    exec 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require('packer')
local util = require('packer.util')

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

packer.startup(function()
  local use = use

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Pretty symbols
  use 'kyazdani42/nvim-web-devicons'

  -- Color scheme
  use 'w0ng/vim-hybrid'

  -- Airline
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Search
  use {
  	{
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      },
    },
    'nvim-telescope/telescope-fzy-native.nvim',
    'jremmen/vim-ripgrep'
  }

  -- Highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  end
)
