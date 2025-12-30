{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
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

      set-option -g status-position top
      set-option -g status-interval 60
      set-option -g status-justify centre

      # Rose Pine Moon color scheme
      # set-option -g status-style "bg=#232136,fg=#e0def4"

      # Left: Session name + prefix indicator
      set-option -g status-left "#[fg=#89b4fa,bold]#{?client_prefix,#[fg=#f38ba8] PREFIX ,} #S "
      set-option -g status-left-length 50

      # Center: Window list (tabs)
      set-option -g window-status-format "#[fg=#6c7086] #I:#W "
      set-option -g window-status-current-format "#[fg=#9399b2,bold,italic] #I:#W "

      # Right: Date and time
      set-option -g status-right "#[fg=#6c7086,bold] %Y-%m-%d %R "
      set-option -g status-right-length 50
    '';
  };
}
