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
      merge.conflictStyle = "diff3";
    };

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkoP+Uu+fdknJf1b4J6ydudNe4FeTqMpDxBmvJiTkzM";
      signByDefault = true;
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
