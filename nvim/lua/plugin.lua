local exec = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  exec("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  exec("packadd packer.nvim")
end

vim.cmd("packadd packer.nvim")

local packer = require("packer")
local util = require("packer.util")

packer.init({
  package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
})

packer.startup(function()
  local use = use

  -- Packer
  use("wbthomason/packer.nvim")

  -- Color Scheme
  use("w0ng/vim-hybrid")

  -- Pretty symbols
  use("kyazdani42/nvim-web-devicons")

  -- File Manager
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- Indent Detection
  use({
    "Darazaki/indent-o-matic",
    config = function()
      require("indent-o-matic").setup({
        filetype_ = {
          standard_widths = { 2, 4 },
        },
      })
    end,
  })

  -- Lualine
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  -- Completion
  use({
    "ms-jpq/coq_nvim",
    requires = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
  })

  -- Language Server Manager
  use({
    "williamboman/mason.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    }
  })

  -- Rooter
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({})
    end,
  })

  -- Search
  use({
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    },
    "nvim-telescope/telescope-fzy-native.nvim",
  })

  -- Syntax Highlighting
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })

  -- Git Diff
  use("sindrets/diffview.nvim")
end)
