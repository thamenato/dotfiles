{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Thales Menato";
    userEmail = "8753631+thamenato@users.noreply.github.com";

    extraConfig = {
      push.autoSetupRemote = true;
      fetch.prune = true;
    };

    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
      st = "status";
    };
  };
}
