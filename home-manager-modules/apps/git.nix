{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };

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
