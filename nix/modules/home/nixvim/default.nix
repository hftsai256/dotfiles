{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) nixvim;

in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      (import ./plugins { inherit pkgs; })
      ./options.nix
      ./keymaps.nix
    ];

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "nvim-treesitter"
        ];
      };
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    extraConfigLua = ''
      for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then
            return
          end
          return default_diagnostic_handler(err, result, context, config)
        end
      end
    '';
  };

  programs.lazygit.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
