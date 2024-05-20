{
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

      export PATH=/home/$USER/.local/bin:$PATH
    '';

    shellAliases = {
      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      # theme = "bureau";
      plugins = [
        "fzf"
        "git"
        "git-auto-fetch"
        "ripgrep"
      ];
    };
  };
  programs.starship = {
    enable = true;
  };
}
