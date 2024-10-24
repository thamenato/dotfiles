{ pkgs, lib, ... }:
{
  home = {
    username = lib.mkForce "thales";
    homeDirectory = lib.mkForce "/home/thales";

    packages = with pkgs; [
      # dependencies/tools
      devenv
      python3
      pipx
    ];

    file = {
      ".config/xxh/config.xxhc".text = ''
        hosts:
          ".*":
            +s: zsh
      '';
    };
  };

  wayland.windowManager.sway =
    let
      monitor_main = "DP-3";
      monitor_right_bottom = "HDMI-A-1";
      monitor_right_top = "HDMI-A-2";
    in
    {
      config = {

        assigns = {
          "2" = [ { class = "firefox"; } ];
          "3" = [ { class = "Slack"; } ];
        };

        window.commands = [
          {
            criteria = {
              class = "1Password";
            };
            command = "floating enable";
          }
        ];

        startup = [
          { command = "1password --silent"; }
          { command = "firefox"; }
          { command = "slack"; }
        ];

        workspaceOutputAssign = [
          {
            workspace = "1";
            output = monitor_main;
          }
          {
            workspace = "2";
            output = monitor_right_bottom;
          }
          {
            workspace = "3";
            output = monitor_right_top;
          }
        ];

        output =
          let
            ultrawide_bg = ../../misc/backgrounds/wallhaven-vql78p_3840x1600.png;
            res_fullhd = "1920x1080";
            res_ultrawide4k = "3840x1600";
          in
          {
            ${monitor_main} = {
              position = "0,580";
              bg = "${ultrawide_bg} fit";
              res = res_ultrawide4k;
            };
            ${monitor_right_bottom} = {
              position = "3840,1080";
              res = res_fullhd;
            };
            ${monitor_right_top} = {
              position = "3840,0";
              res = res_fullhd;
            };
          };
      };
    };
}
