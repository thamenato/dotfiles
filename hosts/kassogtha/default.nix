{backgrounds, ...}: {
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
      wallpapers = {
        "eDP-1" = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
      };
    };
  };
}
