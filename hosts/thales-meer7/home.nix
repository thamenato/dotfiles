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
      mainMonitor = "HDMI-A-1";
    in
    {
      config = {
        assigns = {
          "2" = [
            { class = "firefox"; }
            { class = "Slack"; }
          ];
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
            output = mainMonitor;
          }
          {
            workspace = "2";
            output = mainMonitor;
          }
        ];

        output =
          let
            background = ../../misc/backgrounds/wallhaven-1p5y29_5120x1440.png;
            qhdUltraWide = "5120x1440";
          in
          {
            ${mainMonitor} = {
              position = "0,0";
              bg = "${background} fit";
              res = qhdUltraWide;
            };
          };
      };
    };
}
