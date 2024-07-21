{ config
, pkgs
, ...
}: {
  imports = [
    ./appearance
    ./apps
    ./programming
    ./terminal
  ];

  home.username = "thamenato";
  home.homeDirectory = "/home/thamenato";


  home.packages = with pkgs; [
    # terminal
    alejandra
    fastfetch
    httpie
    jq
    lazydocker
    playerctl
    tldr
    unzip
    xxh
    zip

    # lsp
    marksman
    nil
    terraform-ls
    yaml-language-server

    # formatter/linter
    dprint
    nixpkgs-fmt

    # fonts
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Hack"
        "Noto"
        "JetBrainsMono"
      ];
    })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program /run/current-system/sw/bin/pinentry
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
