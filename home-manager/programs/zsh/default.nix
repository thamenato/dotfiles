{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      save = 10000;
      size = 10000;
    };

    initContent = lib.mkMerge [
      # force this to be at top of .zshrc
      (lib.mkBefore ''
        source ~/.zsh/plugins/powerlevel10k-config
      '')
      # this can go anywhere in the middle
      ''
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_FIND_NO_DUPS

        eval "$(direnv hook zsh)"

        fastfetch

        export PATH=$HOME/.local/bin:$HOME/go/bin:$PATH

        # use bitwarden ssh agent, if bitwarden-desktop is installed
        if command -v bitwarden >/dev/null 2>&1; then
          export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock
        fi
      ''
      # Auto-start tmux at the end
      (lib.mkAfter ''
        # Auto-start tmux with session management
        if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$NO_TMUX" ]; then
          # Check if we're in an interactive shell
          if [[ $- == *i* ]]; then
            # Try to attach to 'default' session, or create it if it doesn't exist
            tmux attach-session -t default 2>/dev/null || tmux new-session -s default
          fi
        fi
      '')
    ];

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./.p10k.zsh;
        file = "p10k.zsh";
      }
    ];
  };
}
