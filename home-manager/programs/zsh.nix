{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      save = 10000;
      size = 10000;
    };

    initExtra = ''
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS

      eval "$(direnv hook zsh)"

      fastfetch

      export PATH=$HOME/.local/bin:$HOME/go/bin:$PATH
    '';

    shellAliases = {
      lg = "lazygit";
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.starship = {
    enable = true;
  };
}
