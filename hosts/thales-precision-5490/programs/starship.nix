{lib, ...}: {
  programs.starship = {
    settings.format = lib.concatStrings [
      "$username"
      "$hostname"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_metrics"
      "$git_status"
    ];
  };
}
