# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # host-specific packages
  environment.systemPackages = with pkgs; [
    amdgpu_top
    discord
    gparted
  ];

  # bluetooth config
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    settings = {
      Policy.AutoEnable = "true";
      General.Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;
  services.udev.extraRules = ''
    # PS5 DualSense controller over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"

    # PS5 DualSense controller over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
  '';

  # nixos modules
  nixosModules.steam = {
    enable = true;
    gamescope = true;
  };

  system.stateVersion = "23.05";
}
