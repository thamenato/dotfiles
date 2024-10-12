{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixosModules.steam;
in
{
  options.nixosModules.steam = {
    enable = lib.mkEnableOption "Enable Steam";
    gamescope = lib.mkEnableOption "Enable Gamescope";
    gamescopeArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "-w"
        "3840"
        "-h"
        "2160"
        "-r"
        "120"
        "--hdr-enabled"
        "--rt"
      ];
      description = "Gamescope args";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          vkd3d-proton
          vkd3d
          proton-ge-bin
          freetype
          wineWowPackages.waylandFull
          gamescope-wsi
          vulkan-loader
        ];

        gamescopeSession.enable = cfg.gamescope;
      };

      gamescope = lib.mkIf cfg.gamescope {
        enable = true;
        capSysNice = true;
        args = cfg.gamescopeArgs;
      };

      # performance boost
      gamemode.enable = true;
    };
  };
}
