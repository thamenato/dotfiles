# modules/home/programs/fzf.nix
{...}: {
  flake.homeModules."programs/fzf" = {...}: {
    programs.fzf = {
      # https://github.com/junegunn/fzf
      enable = true;
    };
  };
}
