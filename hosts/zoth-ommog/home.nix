{ config, pkgs, lib, ... }:
{
  imports = [ ../../home-manager-modules ];

  wayland.windowManager.sway =
    let
      monitorMain = "DP-1";
      monitorRight = "HDMI-A-1";
    in
    {
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

        output =
          let
            fullHD = "1920x1080";
            ultrawide4k = "3840x1600";
            bgMain = ../../misc/backgrounds/wallhaven-d6jzvg_3840x1600.png;
            bgRight = ../../misc/backgrounds/wallhaven-d6yjpm_1920x1080.png;
          in
          {
            ${monitorMain} = {
              position = "0,0";
              bg = "${bgMain} fit";
              res = ultrawide4k;
            };
            ${monitorRight} = {
              position = "3840,580";
              bg = "${bgRight} fit";
              res = fullHD;
            };
          };
      };
    };
}
