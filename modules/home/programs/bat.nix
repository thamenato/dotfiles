# modules/home/programs/bat.nix
{...}: {
  flake.homeModules."programs/bat" = {pkgs, ...}: {
    programs.bat = {
      enable = true;

      extraPackages = with pkgs.bat-extras; [batman];
    };
  };
}
