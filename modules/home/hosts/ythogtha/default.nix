# modules/home/hosts/ythogtha/default.nix
{self, ...}: {
  flake.homeModules."hosts/ythogtha" = {backgrounds, ...}: {
    imports = [
      self.homeModules."wayland/niri"
    ];

    programs.noctalia.settings.wallpaper.default.path = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";

    stylix.image = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
  };
}
