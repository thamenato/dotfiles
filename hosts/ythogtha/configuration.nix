{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # host-specific
  environment.systemPackages = with pkgs; [ gparted ];

  system.stateVersion = "23.05";
}
