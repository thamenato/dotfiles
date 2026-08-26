# modules/home/programs/ruff.nix
{...}: {
  flake.homeModules."programs/ruff" = {...}: {
    programs.ruff = {
      enable = true;
      settings = {
        # https://docs.astral.sh/ruff/settings/
        fix = true;
        # `ruff check --fix` only sorts imports when I is selected, so without
        # this the ruff-fix formatter never organizes imports on save. This is
        # the user-level fallback; a project's own ruff config replaces it whole.
        lint.extend-select = ["I"];
      };
    };
  };
}
