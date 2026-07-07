# modules/home/programs/claude-code.nix
{inputs, ...}: {
  flake.homeModules."programs/claude-code" = {...}: {
    home.file.".claude/statusline.sh" = {
      source = "${inputs.waza}/scripts/statusline.sh";
      executable = true;
    };

    programs.claude-code = {
      enable = true;

      # Waza marketplace + auto-enable its plugin (skills as /waza:think, /waza:check, …)
      marketplaces.waza = inputs.waza;
      settings.enabledPlugins."waza@waza" = true;

      # Waza statusline: context window %, 5h quota, 7d quota
      settings.statusLine = {
        type = "command";
        command = "bash ~/.claude/statusline.sh";
      };

      context = ''
        # Preferences
        Any new preferences or context should always be added to ~/dotfiles (tracked in git), not written ad-hoc to ~/.claude/CLAUDE.md.

        # Git workflow
        - Always rebase onto main (`git fetch origin && git rebase origin/main`), never merge main into a feature branch.
      '';
    };
  };
}
