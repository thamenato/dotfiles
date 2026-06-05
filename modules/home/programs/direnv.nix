# modules/home/programs/direnv.nix
{...}: {
  flake.homeModules."programs/direnv" = {...}: {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
