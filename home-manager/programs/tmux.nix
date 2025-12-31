{pkgs, ...}: {
  programs.tmux = {
    enable = false;
    terminal = "tmux-256color";
    # newSession = true;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      continuum
      resurrect
      sensible
      tmux-powerline
      # tmux-which-key
      vim-tmux-navigator
      yank
    ];

    extraConfig = ''
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Enable RGB colour if running in xterm
      set -as terminal-overrides ",xterm*:Tc"

      # Fix colors for various terminals
      set -as terminal-overrides ",alacritty*:Tc"
      set -as terminal-overrides ",kitty*:Tc"
      set -as terminal-overrides ",ghostty*:Tc"

      # Kill tmux server when no sessions remain
      set -g detach-on-destroy off

      # This is needed for yank plugin to automatically copy anything selected
      # with mouse
      set -g mouse on

      # Status bar config
      # set -g status-position top
      # set -g status-interval 60
      # set -g status-justify centre

      # Left: Session name + prefix indicator
      # set -g status-left "#[fg=#89b4fa,bold]#{?client_prefix,#[fg=#f38ba8] PREFIX ,} #S "
      # set -g status-left-length 50

      # Center: Window list (tabs)
      # set -g window-status-format "#[fg=#6c7086] #I:#W "
      # set -g window-status-current-format "#[fg=#9399b2,bold,italic] #I:#W "

      # Right: Date and time
      # set-option -g status-right "#[fg=#6c7086,bold] %Y-%m-%d %R "
      # set-option -g status-right-length 50

      # Plugin configurations

      # tmux-resurrect: Save and restore tmux sessions
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'

      # tmux-continuum: Automatic session saving
      set -g @continuum-boot 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
