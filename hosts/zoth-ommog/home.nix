{
  wayland.windowManager.sway = let
    monitorMain = "HDMI-A-1";
    monitorRight = "HDMI-A-1";
  in {
    config = {
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = monitorMain;
        }
        {
          workspace = "2";
          output = monitorRight;
        }
      ];

      output = let
        # fullHD = "1920x1080";
        # ultrawide4k = "3840x1600";
        real4k = "3840x2160@120.000Hz";
        bgMain = ../../misc/backgrounds/wallhaven-d6jzvg_3840x2160.png;
      in
        # bgRight = ../../misc/backgrounds/wallhaven-d6yjpm_1920x1080.png;
        {
          ${monitorMain} = {
            position = "0,0";
            bg = "${bgMain} fit";
            # res = ultrawide4k;
            res = real4k;
            scale = "2";
          };
          # ${monitorRight} = {
          #   position = "3840,580";
          #   bg = "${bgRight} fit";
          #   res = fullHD;
          # };
        };
    };
  };
}
