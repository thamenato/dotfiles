{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  environment.systemPackages = with pkgs; [
    system76-firmware
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
  nixosModules = {
    users.natalie.enable = true;
    steam.enable = true;
  };

  system.stateVersion = "23.11";
}
