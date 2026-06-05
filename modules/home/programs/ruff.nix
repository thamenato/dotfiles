# modules/home/programs/ruff.nix
{...}: {
  flake.homeModules."programs/ruff" = {...}: {
    programs.ruff = {
      enable = true;
      settings = {
        # https://docs.astral.sh/ruff/settings/
        fix = true;
      };
    };
  };
}
