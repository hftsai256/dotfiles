{ pkgs, ... }: {
  plugins = {
    gitsigns = {
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

    lazygit.enable = true;
    gitblame.enable = true;

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }
  ];
}
