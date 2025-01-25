{lib, ...}: {
  wayland.windowManager = let
    output = "HDMI-A-1";
    resolution = "3840x2160@120.000Hz";
    background = ../../misc/backgrounds/wallhaven-d6jzvg_3840x2160.png;
  in {
    sway = {
      config = {
        workspaceOutputAssign = [
          {
            inherit output;
            workspace = "1";
          }
          {
            inherit output;
            workspace = "2";
          }
        ];

        output = {
          ${output} = {
            position = "0,0";
            bg = "${background} fit";
            res = resolution;
            scale = "2";
          };
        };
      };
    };
    hyprland = {
      settings = {
        monitor = lib.mkForce ["${output},${resolution},auto,2"];
      };
    };
  };
}
