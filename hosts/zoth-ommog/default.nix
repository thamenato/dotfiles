{backgrounds, ...}: {
  stylix.image = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
  programs.niri.settings.outputs = {
    "HDMI-A-1" = {
      mode = {
        width = 4096;
        height = 2160;
        refresh = 120.000;
      };
      scale = 2;
    };
  };
}
