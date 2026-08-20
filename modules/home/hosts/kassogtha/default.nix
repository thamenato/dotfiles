# modules/home/hosts/kassogtha/default.nix
{self, ...}: {
  flake.homeModules."hosts/kassogtha" = {backgrounds, ...}: {
    imports = [
      self.homeModules."wayland/niri"
    ];

    programs.noctalia.settings.wallpaper = {
      default.path = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
      monitors."eDP-1".path = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
    };
  };
}
