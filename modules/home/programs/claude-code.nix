# modules/home/programs/claude-code.nix
{inputs, ...}: {
  flake.homeModules."programs/claude-code" = {config, ...}: {
    home.file.".claude/statusline.sh" = {
      source = "${inputs.waza}/scripts/statusline.sh";
      executable = true;
    };

    programs.claude-code = {
      enable = true;

      # Marketplaces are declared through `settings` rather than the `marketplaces`
      # option: that option hardcodes source = "directory" (so it can't express a
      # GitHub marketplace) and takes ownership of plugins/known_marketplaces.json,
      # which Claude Code must stay able to write when it clones/refreshes glyd-ai.
      settings.extraKnownMarketplaces = {
        waza.source = {
          source = "directory";
          path = "${inputs.waza}";
        };
        glyd-ai.source = {
          source = "github";
          repo = "glydways/glyd";
        };
        # Points at the working tree rather than the store so skill edits apply
        # without a rebuild.
        thamenato.source = {
          source = "directory";
          path = "${config.home.homeDirectory}/dotfiles/claude";
        };
      };

      settings.enabledPlugins = {
        "waza@waza" = true;
        "devplat@glyd-ai" = true;
        "compute-platform@glyd-ai" = true;
        "thamenato@thamenato" = true;
      };

      # Claude manages the task list directly; a prompt on every `task` call would
      # make that unusable. The Jira entry is the read-only JQL search /thamenato:wip
      # runs on every invocation.
      settings.permissions.allow = [
        "Bash(task:*)"
        "mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql"
      ];

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

        # Python style
        - Prefer `pathlib` over `os.path` for filesystem operations.
        - Model structured data with dataclasses or Pydantic models, not raw dicts.
        - File layout follows Clean Code's stepdown rule (read top-to-bottom like a newspaper): module-level globals first, then classes, then public functions, then the private helpers they call (each helper below its caller).
        - Use `ruff` for both linting and formatting.
      '';
    };
  };
}
