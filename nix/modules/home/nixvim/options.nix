{
  opts = {
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;

    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 0;
    expandtab = true;
    autoindent = true;
    smartindent = true;

    clipboard = "unnamedplus";
    scrolloff = 8;
    updatetime = 250;

    swapfile = false;
    backup = false;
    undofile = true;

    incsearch = true;
    hlsearch = true;

    guifont = [ "monospace:h9" ];
    background = "dark";
    termguicolors = true;

    # Default border for any floating window that doesn't set its own
    # `border` opt (this covers vim.lsp.buf.hover and signature_help,
    # which never did - they no longer need per-function monkey-patching -
    # and, as of the snacks.nvim switch, snacks.picker/explorer too: their
    # layouts pass `border = true`, and snacks resolves that boolean by
    # reading this exact option, falling back to "rounded" only if it's
    # unset). Windows that already pass an explicit border (peek_definition,
    # the diagnostic float, cmp, snacks input/lazygit/terminal, which-key)
    # are unaffected either way. "single" = square corners.
    winborder = "single";
  };

  colorschemes.kanagawa.enable = true;

  extraConfigLua = ''
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
        if not uri then return end

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
        if vim.tbl_isempty(contents) then return end

        local syntax = vim.bo[bufnr].syntax
        if syntax == "" then
          syntax = vim.filetype.match({buf = bufnr}) or ""
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
          vim.api.nvim_win_set_cursor(win, {cursor_line, range.start.character})
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

    -- Diagnostic UI Floating Window configuration
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

    -- Unify every floating surface's colors on plain "Normal": kanagawa
    -- gives FloatBorder/NormalFloat their own dedicated colors (distinct
    -- from Normal), which is why LSP floats, snacks' input/picker/explorer/
    -- terminal/lazygit windows, cmp, and which-key would otherwise all look
    -- slightly different from each other depending on which one happened
    -- to link to which highlight group. Linking FloatBorder/NormalFloat to
    -- Normal here instead makes them all match the same look, once and for
    -- everything, rather than fixing it plugin by plugin.
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

    -- Remove trailing whitespaces upon saving
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {"*.py", "*.rs", "*.c", "*.cpp", "*.lua", "*.nix"},
      callback = function()
        vim.cmd([[%s/\s\+$//e]])
      end,
    })
  '';
}
