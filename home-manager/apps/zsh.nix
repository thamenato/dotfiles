{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtra = ''
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