{ ... }: {
  globals.mapleader = ",";

  keymaps = [
    {
      mode = ["n"];
      key = "<C-e>";
      action = ''
        <Cmd>NvimTreeToggle<CR>
      '';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<leader>b";
      action = ''
        <Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>
      '';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<C-p>";
      action = ''
        <Cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
      '';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<Leader>fg";
      action = ''<Cmd>lua require("telescope.builtin").live_grep()<CR>'';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<Leader>fb";
      action = ''<Cmd>lua require("telescope.builtin").buffers()<CR>'';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<Leader>fh";
      action = ''<Cmd>lua require("telescope.builtin").help_tags()<CR>'';
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<leader><Space>";
      action = "<Cmd>noh<CR>";
      options = { silent = true; };
    }
    {
      mode = ["n"];
      key = "<leader>f";
      action = "<Cmd>Lspsaga finder<CR>";
    }
    {
      mode = ["n"];
      key = "<leader>fi";
      action = "<Cmd>Lspsaga finder imp<CR>";
    }
    { 
      mode = ["n" "v"];
      key = "<leader>ca";
      action = "<Cmd>Lspsaga code_action<CR>";
    }
    {
      mode = ["n"];
      key = "<leader>r";
      action = "<Cmd>Lspsaga rename ++project<CR>";
    }
    {
      mode = ["n"];
      key = "gd";
      action = "<Cmd>Lspsaga peek_definition<CR>";
    }
    {
      mode = ["n"];
      key = "gD";
      action = "<Cmd>Lspsaga goto_definition<CR>";
    }
    {
      mode = ["n"];
      key = "gt";
      action = "<Cmd>Lspsaga peek_type_definition<CR>";
    }
    {
      mode = ["n"];
      key = "gT";
      action = "<Cmd>Lspsaga goto_type_definition<CR>";
    }
    {
      mode = ["n"];
      key = "[e";
      action = "<Cmd>Lspsaga diagnostic_jump_prev<CR>";
    }
    {
      mode = ["n"];
      key = "]e";
      action = "<Cmd>Lspsaga diagnostic_jump_next<CR>";
    }
    {
      mode = ["n"];
      key = "[E";
      action = ''
        <Cmd>lua require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.error }<CR>
      '';
    }
    {
      mode = ["n"];
      key = "]E";
      action = ''
        <Cmd>lua require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.error }<CR>
      '';
    }
    {
      mode = ["n"];
      key = "<leader>o";
      action = "<Cmd>Lspsaga outline<CR>";
    }
    {
      mode = ["n"];
      key = "K";
      action = "<Cmd>Lspsaga hover_doc<CR>";
      options = { desc = "hover.nvim"; };
    }
    {
      mode = ["n"];
      key = "<leader>ci";
      action = "<Cmd>Lspsaga incoming_calls<CR>";
    }
    {
      mode = ["n"];
      key = "<leader>co";
      action = "<Cmd>Lspsaga outgoing_calls<CR>";
    }
    {
      mode = ["n" "t"];
      key = "<a-t>";
      action = "<Cmd>Lspsaga term_toggle<CR>";
    }
    {
      mode = ["n"];
      key = "ff";
      action = "<Cmd>lua vim.lsp.buf.format()<CR>";
    }
  ];
}
