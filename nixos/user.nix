{
  meta,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.users;
in
{
  options.nixosModules.users = {
    natalie.enable = lib.mkEnableOption "Enable Natalie user";
  };
  config = {
    users = {
      users = {
        ${meta.user} = {
          isNormalUser = true;
          description = "Thales Menato";
          extraGroups = [
            "networkmanager"
            "wheel"
            "lp"
            "scanner"
          ];
        };
        nmeusling = lib.mkIf cfg.natalie.enable {
          isNormalUser = true;
          description = "Natalie Menato";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      };
      extraGroups.docker.members = [
        meta.user
        (lib.mkIf cfg.natalie.enable "nmeusling")
      ];
      defaultUserShell = pkgs.zsh;
    };
  };
}
