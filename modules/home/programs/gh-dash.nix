# modules/home/programs/gh-dash.nix
{...}: {
  flake.homeModules."programs/gh-dash" = {...}: {
    programs.gh-dash = {
      enable = true;
    };
  };
}
