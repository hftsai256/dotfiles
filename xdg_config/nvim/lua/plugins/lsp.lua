vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

vim.lsp.config("nil_ls", {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "flake.lock", ".git" },
  settings = {
    ["nil"] = {
      formatting = { command = { "alejandra" } },
      nix = { flake = { autoArchive = false } },
    },
  },
})

vim.lsp.config("pylsp", {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
        pylsp_mypy = { enabled = true, live_mode = false },
        black = { enabled = true },
        ruff = { enabled = true },
        isort = { enabled = true },
        rope_autoimport = { enabled = true },
        rope_completion = { enabled = true },
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      procMacro = { enable = true },
    },
  },
})

vim.lsp.config("ltex", {
  cmd = { "ltex-ls" },
  filetypes = { "tex", "markdown", "text" },
  root_markers = { ".git" },
  settings = {
    ltex = {
      language = "en-US",
    },
  },
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})

vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
})

vim.lsp.config("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
})

vim.lsp.config("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
})

vim.lsp.config("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "svelte",
  },
  root_markers = {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    "package.json",
    ".git",
  },
})

vim.lsp.config("svelte", {
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_markers = { "svelte.config.js", "svelte.config.mjs", "package.json", ".git" },
})

vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "clangd",
  "html",
  "cssls",
  "eslint",
  "svelte",
  "nil_ls",
  "pylsp",
  "rust_analyzer",
  "ltex",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or not client:supports_method("textDocument/completion") then
      return
    end

    local provider = client.server_capabilities.completionProvider
    if type(provider) == "table" then
      local chars = { ".", ":", ">", "'", "/", "_" }
      for c = string.byte("a"), string.byte("z") do
        chars[#chars + 1] = string.char(c)
      end
      for c = string.byte("A"), string.byte("Z") do
        chars[#chars + 1] = string.char(c)
      end
      for c = string.byte("0"), string.byte("9") do
        chars[#chars + 1] = string.char(c)
      end
      provider.triggerCharacters = chars
    end

    local function truncate(text, max)
      text = text or ""
      if vim.fn.strdisplaywidth(text) <= max then
        return text
      end
      return vim.fn.strcharpart(text, 0, math.max(0, max - 1)) .. "…"
    end

    local SNIPPET = vim.lsp.protocol.CompletionItemKind.Snippet -- 15

    local function is_snippet(item)
      local lsp_item = vim.tbl_get(item, "user_data", "nvim", "lsp", "completion_item")
      if lsp_item then
        return lsp_item.kind == SNIPPET
      end
      return item.kind == "Snippet"
    end

    vim.lsp.completion.enable(true, client.id, ev.buf, {
      autotrigger = true,
      convert = function(item)
        return {
          abbr = truncate((item.label or ""):gsub("%b()", ""), 40),
          menu = truncate(item.detail, 18),
        }
      end,
      cmp = function(a, b)
        local sa, sb = is_snippet(a), is_snippet(b)
        if sa ~= sb then
          return not sa -- non-snippet first
        end
        return false
      end,
    })
  end,
})
