require('mason').setup()
require('mason-lspconfig').setup()

local lsp = require("lsp-zero").preset({})
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local keymap = require("cmp.utils.keymap")
local luasnip = require("luasnip")

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup_nvim_cmp({
  mapping = {
    -- from: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
    ["<Tab>"] = cmp.mapping(
      function(fallback)
        -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
        if cmp.visible() then
          print("cmp visible");
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.confirm()
          end
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          if vim.fn.pumvisible() == 0 then
            vim.api.nvim_feedkeys(keymap.t('<C-z>'), 'in', true)
          else
            vim.api.nvim_feedkeys(keymap.t('<C-n>'), 'in', true)
          end
        end
      end, {"i","s","c",}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        if vim.fn.pumvisible() == 0 then
          vim.api.nvim_feedkeys(keymap.t('<C-z><C-p><C-p>'), 'in', true)
        else
          vim.api.nvim_feedkeys(keymap.t('<C-p>'), 'in', true)
        end
      end
    end, {"i", "s"}),
    ['<CR>'] = cmp.mapping.confirm(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
  }
})

-- (Optional) Configure lua language server for neovim
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.tsserver.setup({
  on_attach = function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
  end
})

lsp.setup()

local keymap = vim.keymap.set

-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

-- Code action
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

-- Rename all occurrences of the hovered word for the selected files
keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

-- Go to definition
keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

-- Go to type definition
keymap("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>")


-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show buffer diagnostics
keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Show workspace diagnostics
keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")

-- Show cursor diagnostics
keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[E", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "]E", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- Toggle outline
keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")

-- Hover Doc
-- If there is no hover doc,
-- there will be a notification stating that
-- there is no information available.
-- To disable it just use ":Lspsaga hover_doc ++quiet"
-- Pressing the key twice will enter the hover window
--keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

-- Call hierarchy
keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Floating terminal
keymap({"n", "t"}, "<A-t>", "<cmd>Lspsaga term_toggle<CR>")

