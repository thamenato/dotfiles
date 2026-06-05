# modules/home/programs/yazi.nix
{...}: {
  flake.homeModules."programs/yazi" = {...}: {
    programs.yazi = {
      enable = true;

      enableZshIntegration = true;
      shellWrapperName = "y";
    };
  };
}
