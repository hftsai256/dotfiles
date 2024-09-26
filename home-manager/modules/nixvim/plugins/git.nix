{ pkgs, ... }: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          text = " ";
        };
        change = {
          text = " ";
        };
        delete = {
          text = " ";
        };
        untracked = {
          text = "";
        };
        topdelete = {
          text = "󱂥 ";
        };
        changedelete = {
          text = "󱂧 ";
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    lazygit-nvim
  ];

  extraConfigLua = ''
    require("telescope").load_extension("lazygit")
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }
  ];
}
