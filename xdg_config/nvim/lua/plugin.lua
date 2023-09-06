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

packer.startup(function(use)
  -- Packer
  use({
    "wbthomason/packer.nvim",
    run = function()
      pcall(vim.cmd, "MasonUpdate")
    end
  })

  -- Color Scheme
  use("w0ng/vim-hybrid")
  use("RRethy/nvim-base16")

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
        standard_widths = { 2, 4 },
        max_lines = 1024,
        skip_multiline = true,
      })
    end,
  })

  use({
    "nvimdev/indentmini.nvim",
    event = "BufEnter",
    config = function()
      require("indentmini").setup({
        char = "│"
      })
      vim.cmd.highlight("default link IndentLine NonText")
    end,
  })

  -- Lualine
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  -- Language Server
  --use("neovim/nvim-lspconfig")
  --use {
  --  "lewis6991/hover.nvim",
  --  config = function()
  --    require("hover").setup {
  --      init = function()
  --        -- Require providers
  --        require("hover.providers.lsp")
  --        require('hover.providers.gh')
  --        require('hover.providers.gh_user')
  --        require('hover.providers.jira')
  --        -- require('hover.providers.man')
  --        -- require('hover.providers.dictionary')
  --      end,
  --      preview_opts = {
  --        border = "single"
  --      },
  --      -- Whether the contents of a currently open hover window should be moved
  --      -- to a :h preview-window when pressing the hover keymap.
  --      preview_window = true,
  --      title = true
  --    }
  --  end
  --}

  use({
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").setup({})
    end,
    requires = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
      --Please make sure you install markdown and markdown_inline parser
      "nvim-treesitter/nvim-treesitter"
    }
  })

  --use({
  --  "simrat39/symbols-outline.nvim",
  --  after = {
  --    "nvim-lspconfig",
  --  },
  --  config = function()
  --    require("symbols-outline").setup()
  --  end,
  --  requires = {
  --    "neovim/nvim-lspconfig",
  --  }
  --})

 use({
   "VonHeikemen/lsp-zero.nvim",
   branch = "v2.x"
 })

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip"
    }
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
    end
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
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"c", "cpp", "cmake", "python", "markdown", "markdown_inline", "jsonc", "rust", "lua"},
        indent = { enable = true },
      })
    end
  })

  -- Git Diff
  use("sindrets/diffview.nvim")

  -- Jupyter Connector
  use("untitled-ai/jupyter_ascending.vim")
end)
