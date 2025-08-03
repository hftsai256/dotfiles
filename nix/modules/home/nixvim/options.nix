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

  # Remove trailing whitespaces upon saving
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {"*.py", "*.rs", "*.c", "*.cpp", "*.lua", "*.nix"},
      callback = function()
        vim.cmd([[%s/\s\+$//e]])
      end,
    })
  '';
}
