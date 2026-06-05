# modules/home/programs/ripgrep.nix
{...}: {
  flake.homeModules."programs/ripgrep" = {...}: {
    programs.ripgrep = {
      enable = true;
      arguments = ["--max-columns-preview"];
    };
  };
}
