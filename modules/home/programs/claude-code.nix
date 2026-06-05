# modules/home/programs/claude-code.nix
{...}: {
  flake.homeModules."programs/claude-code" = {...}: {
    programs.claude-code = {
      enable = true;
      context = ''
        # Preferences
        Any new preferences or context should always be added to ~/dotfiles (tracked in git), not written ad-hoc to ~/.claude/CLAUDE.md.

        # Git workflow
        - Always rebase onto main (`git fetch origin && git rebase origin/main`), never merge main into a feature branch.
      '';
    };
  };
}
