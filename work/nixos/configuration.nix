{ config, pkgs, ...}:
let
  nixpkgs_unstable = import <nixos-unstable> { config.allowUnfree = true; };
in
{
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    # packages that I want available in all hosts
    # for host specific, still use the definition
    # inside configuration.nix
    home-manager
    # tools
    _1password-gui
    _1password
    bat
    dig
    git
    gnupg
    htop
    pinentry
    tailscale
    wget
    zsh
    # editor
    helix
    neovim
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # configure programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.hyprland.enable = true;

  # docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "thales" ];

  # services
  services.openssh.enable = true;
  services.tailscale.enable = true;
}