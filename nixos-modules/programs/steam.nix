{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    steam.enable = lib.mkEnableOption "Enable Steam";
  };

  config = lib.mkIf config.steam.enable {
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

        gamescopeSession.enable = true;
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "-w"
          "3840"
          "-h"
          "2160"
          "-r"
          "120"
          "--hdr-enabled"
          "--rt"
        ];
      };

      # performance boost
      gamemode.enable = true;
    };

    # Keeping these just for a WHAT-IF

    # environment.systemPackages = with pkgs; [
    #   gamescope-wsi
    #   vulkan-loader
    # ];

    # nixpkgs.config.packageOverrides = pkgs: {
    #   steam = pkgs.steam.override {
    #     extraPkgs =
    #       pkgs: with pkgs; [
    #         xorg.libXcursor
    #         xorg.libXi
    #         xorg.libXinerama
    #         xorg.libXScrnSaver
    #         libpng
    #         libpulseaudio
    #         libvorbis
    #         stdenv.cc.cc.lib
    #         keyutils
    #         gamescope
    #         gamescope-wsi
    #         vulkan-loader
    #         zenity
    #         wayland
    #       ];
    #   };
    # };
  };
}
