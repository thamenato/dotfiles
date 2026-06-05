# modules/home/programs/gh.nix
{...}: {
  flake.homeModules."programs/gh" = {...}: {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
