{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # terminal
    age
    alejandra
    devenv
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
    nixd
    terraform-ls
    yaml-language-server

    # formatter/linter
    dprint
    nixfmt-rfc-style

    # fonts
    font-awesome
    powerline-fonts
    powerline-symbols
    ibm-plex
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Hack"
        "Noto"
        "JetBrainsMono"
        "SpaceMono"
      ];
    })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
