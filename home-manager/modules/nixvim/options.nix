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
    undodir = ''
      vim.fn.stdpath("config") .. "/undodir"
    '';

    incsearch = true;
    hlsearch = true;

    guifont = [ "monospace:h9" ];
    background = "dark";
    termguicolors = true;
  };

  colorschemes.kanagawa.enable = true;
}
