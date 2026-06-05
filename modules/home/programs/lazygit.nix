# modules/home/programs/lazygit.nix
{...}: {
  flake.homeModules."programs/lazygit" = {...}: {
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          overrideGpg = true;
        };
      };
    };
  };
}
