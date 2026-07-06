# modules/home/programs/claude-code.nix
{inputs, ...}: {
  flake.homeModules."programs/claude-code" = {...}: {
    programs.claude-code = {
      enable = true;

      # Waza marketplace + auto-enable its plugin (skills as /waza:think, /waza:check, …)
      marketplaces.waza = inputs.waza;
      settings.enabledPlugins."waza@waza" = true;

      context = ''
        # Preferences
        Any new preferences or context should always be added to ~/dotfiles (tracked in git), not written ad-hoc to ~/.claude/CLAUDE.md.

        # Git workflow
        - Always rebase onto main (`git fetch origin && git rebase origin/main`), never merge main into a feature branch.
      '';
    };
  };
}
