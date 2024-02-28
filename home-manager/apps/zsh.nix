{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtra = ''
      eval "$(direnv hook zsh)"

      fastfetch

      export PATH=/home/$USER/.local/bin:$PATH
    '';

    shellAliases = {
      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      theme = "bureau";
      plugins = [
        "fzf"
        "git"
        "git-auto-fetch"
        "ripgrep"
      ];
    };
  };
}
