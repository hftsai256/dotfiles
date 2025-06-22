{ pkgs, specialArgs, lib, ... }:
let
  nix_shell = if (builtins.hasAttr "nix_shell" specialArgs)
    then specialArgs.nix_shell
    else false;

in
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    enableZshIntegration = true;
  };

  programs.fzf.enable = true;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    package = if nix_shell then pkgs.zsh else pkgs.null;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      lg = "lazygit";
      br = "broot";
      py = "python3";
      jnb = "jupyter notebook";
      ipy = "ipython";
    };

    initContent = ''
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta"
      export EDITOR=$(which $EDITOR)
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k;
        file = "p10k.zsh";
      }
    ];
  };
}
