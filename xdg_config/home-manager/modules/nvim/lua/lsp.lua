vim.lsp.set_log_level("ERROR")

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("lspconfig").bashls.setup({})
require("lspconfig").nil_ls.setup({})
require("lspconfig").lua_ls.setup({})
require("lspconfig").pylsp.setup({})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").clangd.setup({})


require('lspsaga').setup({})

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  }),
})

local keymap = vim.keymap.set
keymap("n"         , "<leader>f"  , "<cmd>Lspsaga finder<CR>")
keymap({ "n", "v" }, "<leader>ca" , "<cmd>Lspsaga code_action<CR>")
keymap("n"         , "<leader>r"  , "<cmd>Lspsaga rename ++project<CR>")
keymap("n"         , "gd"         , "<cmd>Lspsaga peek_definition<CR>")
keymap("n"         , "gD"         , "<cmd>Lspsaga goto_definition<CR>")
keymap("n"         , "gt"         , "<cmd>Lspsaga peek_type_definition<CR>")
keymap("n"         , "gT"         , "<cmd>Lspsaga goto_type_definition<CR>")
keymap("n"         , "[e"         , "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n"         , "]e"         , "<cmd>Lspsaga diagnostic_jump_next<CR>")
keymap("n"         , "[E"         , function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n"         , "]E"         , function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n"         , "<leader>o"  , "<cmd>Lspsaga outline<CR>")
keymap("n"         , "K"          , "<cmd>Lspsaga hover_doc<CR>", { desc = "hover.nvim" })
keymap("n"         , "<Leader>ci" , "<cmd>Lspsaga incoming_calls<CR>")
keymap("n"         , "<Leader>co" , "<cmd>Lspsaga outgoing_calls<CR>")
keymap({ "n", "t" }, "<A-t>"      , "<cmd>Lspsaga term_toggle<CR>")
keymap("n"         , "ff"         , "<cmd>lua vim.lsp.buf.format()<CR>")
