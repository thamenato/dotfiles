{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # cli tools
    bat
    dig
    git
    gnupg
    htop
    lf
    pinentry
    python3
    wget
    # terminal
    kitty
    alacritty
    # editor
    helix
    neovim
    # apps
    easyeffects
    firefox
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # configure gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = null;
  };

  # https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_7;
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
