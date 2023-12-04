{
  config,
  pkgs,
  ...
}: let
  unstable = import (
    builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master
  ) {config = config.nixpkgs.config;};
in {
  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    # browser
    vivaldi
    vivaldi-ffmpeg-codecs
    firefox
    # slack
    kitty
    alacritty
    # unstable.vscode
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [zsh];
  environment.pathsToLink = ["/share/zsh"];
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;
  hardware.opengl.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # configure programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      bip = "172.26.0.1/24";
      dns = ["1.1.1.1" "8.8.8.8"];
    };
  };
  users.extraGroups.docker.members = ["thales"];

  # services
  services.openssh.enable = true;
  services.tailscale.enable = true;
}
