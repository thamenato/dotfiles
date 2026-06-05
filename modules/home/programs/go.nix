# modules/home/programs/go.nix
{...}: {
  flake.homeModules."programs/go" = {...}: {
    programs.go = {
      enable = true;
    };
  };
}
