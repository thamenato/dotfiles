{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtra = ''
      eval "$(direnv hook zsh)"

      fastfetch
    '';

    oh-my-zsh = {
      enable = true;
      theme = "bureau";
      plugins = [
        "fzf"
        "git"
        "git-auto-fetch"
      ];
    };
  };
}
