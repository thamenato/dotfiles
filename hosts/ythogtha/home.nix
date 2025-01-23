{
  wayland.windowManager.sway = let
    monitorMain = "DP-1";
  in {
    config = {
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = monitorMain;
        }
      ];

      output = let
        qhdUltraWide = "5120x1440";
        bgMain = ../../misc/backgrounds/wallhaven-d522z3_5120x1440.png;
      in {
        ${monitorMain} = {
          position = "0,0";
          bg = "${bgMain} fit";
          res = qhdUltraWide;
        };
      };
    };
  };
}
