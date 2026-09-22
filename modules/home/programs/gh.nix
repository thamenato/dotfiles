# modules/home/programs/gh.nix
{...}: {
  flake.homeModules."programs/gh" = {pkgs, ...}: {
    programs.gh = {
      enable = true;
      extensions = [pkgs.gh-stack];
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
