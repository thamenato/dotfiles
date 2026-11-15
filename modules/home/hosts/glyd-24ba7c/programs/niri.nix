# modules/home/hosts/glyd-24ba7c/programs/niri.nix
{...}: {
  flake.homeModules."hosts/glyd-24ba7c/programs/niri" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # Shadows /etc/xdg/systemd/user/niri.service, which starts a hand-installed /usr/bin/niri.
    # X-SwitchMethod=keep-old: without it, sd-switch restarts niri whenever the unit changes
    # (every niri bump), killing the session and leaving an orphaned niri.service behind
    # that makes the next niri-session login fail with "A niri session is already running".
    xdg.configFile."systemd/user/niri.service".source = pkgs.runCommand "niri.service" {} ''
      cat ${config.programs.niri.package}/share/systemd/user/niri.service > $out
      printf '\n[Unit]\nX-SwitchMethod=keep-old\n' >> $out
    '';

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

        # The NVIDIA dGPU drives no outputs; holding it open keeps it out of runtime D3.
        debug = {
          render-drm-device = ["/dev/dri/by-path/pci-0000:00:02.0-render"];
          ignore-drm-device = ["/dev/dri/by-path/pci-0000:01:00.0-render"];
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
              width = 2560;
              height = 1600;
              refresh = 90.0;
            };
            scale = 1.6;
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
