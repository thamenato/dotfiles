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

    sops.secrets = {
      # user passwords
      ${meta.user}.neededForUsers = true;
      nmeusling.neededForUsers = lib.mkIf cfg.natalie.enable true;
    };

    users = {
      users = {
        ${meta.user} = {
          isNormalUser = true;
          description = "Thales Menato";
          hashedPasswordFile = config.sops.secrets.${meta.user}.path;
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
          hashedPasswordFile = config.sops.secrets.nmeusling.path;
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
