# modules/home/qt.nix
# Qt theme configuration
{...}: {
  flake.homeModules.qt = {...}: {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };
  };
}
