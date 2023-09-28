{ config, pkgs, ...}:
{
 environment.systemPackages = with pkgs; [
  # packages that I want available in all hosts
  # for host specific, still use the definition
  # inside configuration.nix
    home-manager
    # tools
    bat
    git
    htop
    python311
    wget
    zsh
    gnupg
    pinentry
    easyeffects
    # editor
    helix
    neovim
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # configure gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
