local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 0
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true


-- Builtin: honors .editorconfig indent_size/indent_style.
-- Content guessing is vim-sleuth.
vim.g.editorconfig = true

opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.updatetime = 250

opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.incsearch = true
opt.hlsearch = true

opt.guifont = "monospace:h9"
opt.background = "dark"
opt.termguicolors = true

opt.winborder = "single"
opt.pumborder = "single"
opt.completeopt = { "menuone", "noselect", "noinsert", "popup" }
opt.complete:append("o")

-- Floating Peek Definition with File Path Title
-- Shows a block of surrounding context rather than just the (often
-- single-line) symbol range the server returns, and centers the
-- cursor on the actual target line within that block.
function _G.peek_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("Definition not found", vim.log.levels.WARN)
      return
    end

    local location = vim.islist(result) and result[1] or result
    local uri = location.uri or location.targetUri
    if not uri then
      return
    end

    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end

    local fname = vim.uri_to_fname(uri)
    local display_name = vim.fn.fnamemodify(fname, ":~:.")
    local range = location.range or location.targetSelectionRange
    local line_num = range.start.line + 1

    -- Lines of context to show before/after the target line.
    local context_before, context_after = 8, 15
    local total_lines = vim.api.nvim_buf_line_count(bufnr)
    local start_line = math.max(0, range.start.line - context_before)
    local end_line = math.min(total_lines, range.start.line + context_after)

    local contents = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
    if vim.tbl_isempty(contents) then
      return
    end

    local syntax = vim.bo[bufnr].syntax
    if syntax == "" then
      syntax = vim.filetype.match({ buf = bufnr }) or ""
    end

    local _, win = vim.lsp.util.open_floating_preview(contents, syntax, {
      border = "single",
      title = string.format(" %s:%d ", display_name, line_num),
      title_pos = "center",
      focus_id = "location",
      focusable = true,
      max_height = 25,
      max_width = 120,
    })

    if win and vim.api.nvim_win_is_valid(win) then
      local cursor_line = range.start.line - start_line + 1
      vim.api.nvim_win_set_cursor(win, { cursor_line, range.start.character })
      vim.api.nvim_win_call(win, function()
        vim.cmd("normal! zz")
      end)
    end
  end)
end

-- Toggle the file explorer (leader-e).
-- snacks.explorer is picker-based, and pickers don't have a "toggle" of
-- their own - opening it again while it's already open just refocuses
-- the existing window rather than closing it. This checks whether an
-- explorer picker instance already exists and closes it if so,
-- otherwise opens a fresh one, to give back the NvimTreeToggle-style
-- single-key toggle this config used to have for free.
function _G.toggle_explorer()
  local open = Snacks.picker.get({ source = "explorer" })
  if #open > 0 then
    open[1]:close()
  else
    Snacks.explorer.open()
  end
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "single",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py", "*.rs", "*.c", "*.cpp", "*.lua", "*.nix" },
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust" },
  callback = function(args)
    vim.treesitter.stop(args.buf)
  end,
})
