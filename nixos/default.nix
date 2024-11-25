{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./localization.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./services.nix
    ./sops.nix
    ./system-packages.nix
    ./user.nix
    ./virtualization.nix
    ./xdg.nix
    ./programs
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
