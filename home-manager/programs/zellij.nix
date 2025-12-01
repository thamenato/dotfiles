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

      keybinds = {
        # Unbind Ctrl+n and Ctrl+p to avoid conflicts with Neovim
        unbind = ["Ctrl n" "Ctrl p"];

        normal = {
          # Use Alt+n and Alt+p for pane navigation instead
          "bind \"Alt n\"" = {NewPane = [];};
          "bind \"Alt p\"" = {SwitchToMode = "Pane";};
        };
      };
    };
  };
}
