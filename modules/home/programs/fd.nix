# modules/home/programs/fd.nix
{...}: {
  flake.homeModules."programs/fd" = {...}: {
    programs.fd = {
      enable = true;
    };
  };
}
