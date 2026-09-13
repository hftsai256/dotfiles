require("hybrid").setup({ transparent = true })
vim.cmd.colorscheme("hybrid")

-- foot already applies background alpha. Clearing nvim's background
-- lets that terminal alpha show through instead of painting an opaque canvas.
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

require("lualine").setup()
require("nvim-web-devicons").setup()

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
})

require("gitsigns").setup({
  signs = {
    add = { text = " " },
    change = { text = " " },
    delete = { text = " " },
    untracked = { text = "" },
    topdelete = { text = "󱂥 " },
    changedelete = { text = "󱂧 " },
  },
})

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "tectonic"

require("render-markdown").setup({
  latex = { enabled = false },
})

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if args.match == "rust" then
      return
    end
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-ts-autotag").setup()
require("nvim-surround").setup()
require("nvim-autopairs").setup()
require("which-key").setup({
  win = { border = "single" },
})
