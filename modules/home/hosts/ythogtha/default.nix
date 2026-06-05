# modules/home/hosts/ythogtha/default.nix
{self, ...}: {
  flake.homeModules."hosts/ythogtha" = {backgrounds, ...}: {
    imports = [
      self.homeModules."wayland/niri"
    ];

    stylix.image = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
  };
}
