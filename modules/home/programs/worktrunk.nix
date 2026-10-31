# modules/home/programs/worktrunk.nix
{...}: {
  flake.homeModules."programs/worktrunk" = {...}: {
    programs.worktrunk = {
      enable = true;
      settings = {
        skip-shell-integration-prompt = true;
        worktree-path = "{{ repo_path }}/../{{ repo }}-worktrees/{{ branch | sanitize }}";
      };
    };
  };
}
