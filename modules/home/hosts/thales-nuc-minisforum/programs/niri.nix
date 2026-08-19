# modules/home/hosts/thales-nuc-minisforum/programs/niri.nix
{...}: {
  flake.homeModules."hosts/thales-nuc-minisforum/programs/niri" = {
    backgrounds,
    config,
    lib,
    ...
  }: {
    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
        wallpapers = {
          "DP-1" = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
        };
      };
    };
    programs.niri = {
      settings = {
        spawn-at-startup = [
          {argv = ["1password"];}
          {argv = ["slack"];}
        ];

        binds = with config.lib.niri.actions; {
          "Ctrl+Alt+L" = lib.mkForce {
            action = spawn "noctalia" "msg" "session" "lock";
            hotkey-overlay.title = "Lock the Screen";
          };
        };

        outputs = {
          "DP-1" = {
            # single monitor -- no mode set, so niri uses the preferred one
            position = {
              x = 0;
              y = 0;
            };
          };
        };
      };
    };
  };
}
