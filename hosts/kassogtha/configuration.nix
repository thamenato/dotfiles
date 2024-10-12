{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Extra User account
  users = {
    users = {
      nmenato = {
        isNormalUser = true;
        description = "Natalie Menato";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
    extraGroups.docker.members = [ "nmenato" ];
  };

  environment.systemPackages = with pkgs; [
    system76-firmware
    path-of-building
  ];

  # laptop battery optimization
  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  # nixos modules
  nixosModules.steam.enable = true;

  system.stateVersion = "23.11";
}
