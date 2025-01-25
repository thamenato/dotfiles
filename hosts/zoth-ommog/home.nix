{lib, ...}: {
  wayland.windowManager = let
    output = "HDMI-A-1";
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

        output = let
          real4k = "3840x2160@120.000Hz";
          bgMain = ../../misc/backgrounds/wallhaven-d6jzvg_3840x2160.png;
        in {
          ${output} = {
            position = "0,0";
            bg = "${bgMain} fit";
            res = real4k;
            scale = "2";
          };
        };
      };
    };
    hyprland = {
      settings = {
        monitor = lib.mkForce ["${output},preferred,auto,2"];
      };
    };
  };
}
