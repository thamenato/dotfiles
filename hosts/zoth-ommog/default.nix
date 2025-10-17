{backgrounds, ...}: {
  services.hyprpaper.settings = {
    preload = builtins.attrValues backgrounds;
    wallpaper = [",${backgrounds."wallhaven-d6jzvg_3840x2160.png"}"];
  };
}
