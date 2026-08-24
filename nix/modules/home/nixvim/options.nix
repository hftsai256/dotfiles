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
  };

  colorschemes.kanagawa.enable = true;

  extraConfigLua = ''
    -- Force vim.lsp.buf.hover to always pass squared borders
    local orig_hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function(opts)
      opts = opts or {}
      opts.border = "single"
      return orig_hover(opts)
    end

    -- Force signature help to use squared borders
    local orig_sig = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function(opts)
      opts = opts or {}
      opts.border = "single"
      return orig_sig(opts)
    end

    -- Floating Peek Definition with File Path Title
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

        local fname = vim.uri_to_fname(uri)
        local display_name = vim.fn.fnamemodify(fname, ":~:.")
        local range = location.range or location.targetSelectionRange
        local line_num = range.start.line + 1

        vim.lsp.util.preview_location(location, {
          border = "single",
          title = string.format(" %s:%d ", display_name, line_num),
          title_pos = "center",
        })
      end)
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

    -- Fix Kanagawa/theme float border invisibility
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7E9CD8", bg = "NONE" })

    -- Remove trailing whitespaces upon saving
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {"*.py", "*.rs", "*.c", "*.cpp", "*.lua", "*.nix"},
      callback = function()
        vim.cmd([[%s/\s\+$//e]])
      end,
    })
  '';
}
