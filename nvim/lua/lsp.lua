vim.g.coq_settings = { auto_start = "shut-up" }

local nvim_lsp = require("lspconfig")
local coq = require("coq")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  local function has_shift(str)
    string.find(str, "S-")
  end
  local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t("<C-n>") or t("<Tab>")
  end

  function _G.smart_stab()
    return vim.fn.pumvisible() == 1 and t("<C-p>") or t("<S-Tab>")
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Autocompletion
  buf_set_keymap("i", "<Tab>", [[v:lua.smart_tab()]], { expr = true, noremap = true })
  buf_set_keymap("i", "<S-Tab>", [[v:lua.smart_stab()]], { expr = true, noremap = true })
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  {
    name = "clangd",
    -- opts = {compilationDatabaseDirectory = 'build',
    --         cache = {directory='/tmp/ccls-cache'}}
    opts = { filetypes = { "c", "cc", "cpp", "objc", "objcpp" } },
  },
  { name = "pyright", opts = {} },
  { name = "bashls", opts = {} },
  { name = "lua_ls", opts = {} },
  { name = "cmake", opts = {} },
}

for i, lsp in ipairs(servers) do
  nvim_lsp[lsp.name].setup(coq.lsp_ensure_capabilities({
    init_options = lsp.opts,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }))
end
