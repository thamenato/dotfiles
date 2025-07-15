{pkgs, ...}: {
  programs.taskwarrior = {
    package = pkgs.taskwarrior3;
    enable = true;
  };
}
