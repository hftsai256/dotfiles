{ config, pkgs, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  kitty-pkg = {
    native = pkgs.kitty;
    nixgl = pkgs.kitty-nixgl;
    null = pkgs.null;
  };

  foot-pkg = {
    native = pkgs.foot;
    nixgl = pkgs.foot-nixgl;
    null = pkgs.null;
  };

in {
  options = {
    term.app = lib.options.mkOption {
      type = lib.types.enum ["kitty" "foot"];
      default = "foot";
      description = ''
        Terminal application. Supported options are:
          "kitty", "foot"
      '';
    };
  };

  config = {
    home.packages = [
      pkgs.xdg-terminal-exec
      pkgs.tmux
      pkgs.wofi
    ] ++ lib.optional (config.term.app == "foot") foot-pkg."${config.gfx}"
      ++ lib.optional (config.term.app == "kitty") kitty-pkg."${config.gfx}";

    home.file = {
      ".tmux/plugins/cpu".source =
        "${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu";
      ".tmux/plugins/resurrect".source =
        "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
      ".tmux/plugins/continuum".source =
        "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";
    };

    xdg.desktopEntries.tmux-pick = {
      name = "tmux sessions";
      exec = "${homeDirectory}/.local/bin/tmux-pick gui";
      terminal = false;
      categories = ["System" "Utility"];
    };

    xdg.configFile."tmux".source =
      mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/tmux";
    xdg.configFile."foot".source =
      mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/foot";
    xdg.configFile."kitty".source =
      mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/kitty";
    xdg.configFile."wofi".source =
      mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/xdg_config/wofi";

  };
}
