{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Thales Menato";
    userEmail = "8753631+thamenato@users.noreply.github.com";

    extraConfig = {
      push.autoSetupRemote = true;
      fetch.prune = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      rerere.enabled = true;
    };

    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
      st = "status";
      sw = "switch";
      root = "rev-parse --show-toplevel";
    };
  };
}
