# modules/home/services/easyeffects.nix
{...}: {
  flake.homeModules."services/easyeffects" = {...}: {
    services.easyeffects = {
      enable = true;
    };
  };
}
