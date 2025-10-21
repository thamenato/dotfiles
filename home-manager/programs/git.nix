{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Thales Menato";
        email = "8753631+thamenato@users.noreply.github.com";
      };

      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;

      alias = {
        pu = "push";
        co = "checkout";
        cm = "commit";
        st = "status";
        sw = "switch";
        root = "rev-parse --show-toplevel";
      };
    };

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkoP+Uu+fdknJf1b4J6ydudNe4FeTqMpDxBmvJiTkzM";
      signByDefault = true;
    };
  };
}
