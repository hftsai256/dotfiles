local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  gh("folke/snacks.nvim"),
  gh("HoNamDuong/hybrid.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("lewis6991/gitsigns.nvim"),
  gh("lervag/vimtex"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-lualine/lualine.nvim"),
  gh("tpope/vim-sleuth"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("windwp/nvim-ts-autotag"),
  gh("kylechui/nvim-surround"),
  gh("windwp/nvim-autopairs"),
  gh("folke/which-key.nvim"),
  gh("alexghergh/nvim-tmux-navigation"),
}, { confirm = false, load = true })

require("config")
