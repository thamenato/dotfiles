# modules/home/programs/mergiraf.nix
{...}: {
  flake.homeModules."programs/mergiraf" = {...}: {
    programs.mergiraf = {
      enable = true;

      enableGitIntegration = true;
    };
  };
}
