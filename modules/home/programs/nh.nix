# modules/home/programs/nh.nix
{...}: {
  flake.homeModules."programs/nh" = {...}: {
    programs.nh = {
      enable = true;

      homeFlake = "$HOME/dotfiles";
      osFlake = "$HOME/Projects/nixos-hosts";
    };
  };
}
