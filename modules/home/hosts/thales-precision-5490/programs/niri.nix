# modules/home/hosts/thales-precision-5490/programs/niri.nix
{...}: {
  flake.homeModules."hosts/thales-precision-5490/programs/niri" = {
    config,
    lib,
    ...
  }: {
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
          "DP-3" = {
            # samsung (main)
            mode = {
              width = 5120;
              height = 1440;
              refresh = 143.987;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
          "eDP-1" = {
            # laptop (left)
            mode = {
              width = 1920;
              height = 1200;
              refresh = 60.026;
            };
            scale = 1;
            position = {
              x = 5120;
              y = 0;
            };
          };
          #"DP-2" = {
          #  # portable (right)
          #  mode = {
          #    width = 1920;
          #    height = 1080;
          #    refresh = 60.000;
          #  };
          #  position = {
          #    x = 1920 * 2;
          #    y = 0;
          #  };
          #};
        };
      };
    };
  };
}
