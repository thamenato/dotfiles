{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ../../home-manager-modules
  ];

  home.username = lib.mkForce "thales";
  home.homeDirectory = lib.mkForce "/home/thales";

  home.packages = with pkgs; [
    # dependencies/tools
    devenv
    python3
    pipx
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/xxh/config.xxhc".text = ''
      hosts:
        ".*":
          +s: zsh
    '';
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
          "2" = [{ class = "Brave-browser"; }];
          "3" = [{ class = "Slack"; }];
        };

        window.commands = [
          {
            criteria = { class = "1Password"; };
            command = "floating enable";
          }
        ];

        startup = [
          { command = "1password --silent"; }
          { command = "brave"; }
          { command = "slack --startup"; }
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
