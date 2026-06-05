# modules/home/programs/taskwarrior.nix
{...}: {
  flake.homeModules."programs/taskwarrior" = {pkgs, ...}: {
    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;
    };
  };
}
