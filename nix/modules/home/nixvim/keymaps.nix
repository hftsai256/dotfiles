{...}: {
  globals.mapleader = ",";

  keymaps = [
    # File Tree & Navigation
    {
      mode = ["n"];
      key = "<C-e>";
      action = "<Cmd>NvimTreeToggle<CR>";
      options = {silent = true;};
    }

    # Telescope
    {
      mode = ["n"];
      key = "<leader>b";
      action = "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>";
      options = {silent = true;};
    }
    {
      mode = ["n"];
      key = "<C-p>";
      action = "<Cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>";
      options = {silent = true;};
    }
    {
      mode = ["n"];
      key = "<Leader>fg";
      action = "<Cmd>lua require('telescope.builtin').live_grep()<CR>";
      options = {silent = true;};
    }
    {
      mode = ["n"];
      key = "<Leader>fb";
      action = "<Cmd>lua require('telescope.builtin').buffers()<CR>";
      options = {silent = true;};
    }
    {
      mode = ["n"];
      key = "<Leader>fh";
      action = "<Cmd>lua require('telescope.builtin').help_tags()<CR>";
      options = {silent = true;};
    }
    {
      mode = ["n"];
      key = "<leader>o";
      action = "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
      options = {
        silent = true;
        desc = "Document symbols";
      };
    }

    # General Utilities
    {
      mode = ["n"];
      key = "<leader><Space>";
      action = "<Cmd>noh<CR>";
      options = {silent = true;};
    }

    # Native LSP Actions
    {
      mode = ["n"];
      key = "gd";
      action = "<Cmd>lua _G.peek_definition()<CR>";
      options = {desc = "Peek definition";};
    }
    {
      mode = ["n"];
      key = "gD";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
      options = {desc = "Jump to definition";};
    }
    {
      mode = ["n"];
      key = "gt";
      action = "<Cmd>lua vim.lsp.buf.type_definition()<CR>";
      options = {desc = "Go to type definition";};
    }
    {
      mode = ["n"];
      key = "K";
      action = "<Cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<CR>";
      options = {desc = "Hover documentation";};
    }
    {
      mode = ["n"];
      key = "<leader>f";
      action = "<Cmd>lua require('telescope.builtin').lsp_references()<CR>";
      options = {desc = "LSP references";};
    }
    {
      mode = ["n"];
      key = "<leader>fi";
      action = "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>";
      options = {desc = "LSP implementations";};
    }
    {
      mode = ["n" "v"];
      key = "<leader>ca";
      action = "<Cmd>lua vim.lsp.buf.code_action()<CR>";
      options = {desc = "Code actions";};
    }
    {
      mode = ["n"];
      key = "<leader>r";
      action = "<Cmd>lua vim.lsp.buf.rename()<CR>";
      options = {desc = "Rename symbol";};
    }
    {
      mode = ["n"];
      key = "<leader>ci";
      action = "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>";
      options = {desc = "Incoming calls";};
    }
    {
      mode = ["n"];
      key = "<leader>co";
      action = "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>";
      options = {desc = "Outgoing calls";};
    }
    {
      mode = ["n"];
      key = "ff";
      action = "<Cmd>lua vim.lsp.buf.format()<CR>";
      options = {desc = "Format buffer";};
    }

    # Native Diagnostics
    {
      mode = ["n"];
      key = "[e";
      action = "<Cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>";
      options = {desc = "Previous diagnostic";};
    }
    {
      mode = ["n"];
      key = "]e";
      action = "<Cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
      options = {desc = "Next diagnostic";};
    }
    {
      mode = ["n"];
      key = "[E";
      action = "<Cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
      options = {desc = "Previous error";};
    }
    {
      mode = ["n"];
      key = "]E";
      action = "<Cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
      options = {desc = "Next error";};
    }
    {
      mode = ["n"];
      key = "<leader>d";
      action = "<Cmd>lua vim.diagnostic.open_float()<CR>";
      options = {desc = "Show line diagnostic float";};
    }
  ];
}
