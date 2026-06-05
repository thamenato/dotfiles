# modules/home/programs/zoxide.nix
{...}: {
  flake.homeModules."programs/zoxide" = {...}: {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;

      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
