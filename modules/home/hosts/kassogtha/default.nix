# modules/home/hosts/kassogtha/default.nix
{self, ...}: {
  flake.homeModules."hosts/kassogtha" = {backgrounds, ...}: {
    imports = [
      self.homeModules."wayland/niri"
    ];

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
        wallpapers = {
          "eDP-1" = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
        };
      };
    };
  };
}
