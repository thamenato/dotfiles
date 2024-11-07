{
  imports = [ ./steam.nix ];

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/$USER/dotfiles";
    };

    sway.enable = true;

    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryPackage = null;
    };
  };
}
