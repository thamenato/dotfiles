# modules/home/hosts/zoth-ommog/default.nix
{self, ...}: {
  flake.homeModules."hosts/zoth-ommog" = {backgrounds, ...}: {
    imports = [
      self.homeModules."wayland/niri"
    ];

    programs = {
      noctalia.settings.wallpaper = {
        default.path = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
        monitors."HDMI-A-1".path = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
      };

      niri.settings = {
        outputs = {
          "HDMI-A-1" = {
            mode = {
              width = 4096;
              height = 2160;
              refresh = 120.000;
            };
            scale = 2;
          };
        };
      };
    };
  };
}
