{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../nixos-modules
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "kassogtha"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thamenato = {
    isNormalUser = true;
    description = "Thales Menato";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      system76-firmware
      # hyprland/sway dependencies
      rofi
      mako
    ];
  };
  users.extraGroups.docker.members = [ "thamenato" ];

  users.users.nmenato = {
    isNormalUser = true;
    description = "Natalie Menato";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [ ];
  };

  # nixos
  steam.enable = true;

  programs.hyprland.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
