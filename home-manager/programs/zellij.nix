{
  programs.zellij = {
    enable = true;

    attachExistingSession = true;
    enableZshIntegration = true;
    exitShellOnExit = true;

    settings = {
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };
}
