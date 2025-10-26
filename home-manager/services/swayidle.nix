{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.services.swayidle;
in {
  options = {
    services.swayidle = {
      lockscreenCommand = mkOption {
        type = types.str;
        default = "hyprlock";
      };
    };
  };

  config = {
    services.swayidle = {
      enable = true;

      events = [
        {
          event = "before-sleep";
          command = "${cfg.lockscreenCommand}";
        }
      ];

      timeouts = [
        {
          timeout = 300;
          command = "${cfg.lockscreenCommand}";
        }
        {
          timeout = 600;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
      ];
    };
  };
}
