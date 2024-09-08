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
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    programs.gamemode.enable = true;
  };
}
