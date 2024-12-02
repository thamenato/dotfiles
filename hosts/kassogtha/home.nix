{
  home = {
    # packages = with pkgs; [];
  };

  wayland.windowManager.sway =
    let
      monitor_main = "eDP-1";
    in
    {
      config = {
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = monitor_main;
          }
        ];

        output =
          let
            ultrawide_bg = ../../misc/backgrounds/wallhaven-kxo38d_1920x1080.png;
            res_fullhd = "1920x1080";
          in
          {
            ${monitor_main} = {
              position = "0,0";
              bg = "${ultrawide_bg} fit";
              res = res_fullhd;
            };
          };
      };
    };
}
