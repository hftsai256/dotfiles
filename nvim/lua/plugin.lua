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

  -- Color Scheme
  -- use 'RRethy/nvim-base16'
  use 'w0ng/vim-hybrid'
  use 'PHSix/nvim-hybrid'

  -- Pretty symbols
  use 'kyazdani42/nvim-web-devicons'

  -- File Manager
  use 'lambdalisue/fern.vim'

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

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
    'nvim-telescope/telescope-fzy-native.nvim'
  }

  -- Highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  -- Completion
  use 'nvim-lua/completion-nvim'

  -- Git Diff
  use 'sindrets/diffview.nvim'

  end
)
