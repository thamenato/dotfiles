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
      theme = "eastwood";
      plugins = [
        "fzf"
        "git"
        "git-auto-fetch"
      ];
    };
  };
}