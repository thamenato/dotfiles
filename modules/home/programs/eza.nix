# modules/home/programs/eza.nix
{...}: {
  flake.homeModules."programs/eza" = {...}: {
    programs.eza = {
      # https://github.com/eza-community/eza
      enable = true;

      git = true;
      icons = "auto";
      extraOptions = [];
    };
  };
}
