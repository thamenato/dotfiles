# modules/home/programs/claude-code.nix
{...}: {
  flake.homeModules."programs/claude-code" = {...}: {
    programs.claude-code = {
      enable = true;
    };
  };
}
