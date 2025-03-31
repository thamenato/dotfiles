{backgrounds, ...}: {
  services.hyprpaper.settings = {
    preload = builtins.attrValues backgrounds;
    wallpaper = [",${backgrounds."wallhaven-kxo38d_1920x1080.png"}"];
  };
}
