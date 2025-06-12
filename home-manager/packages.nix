{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal
    age
    alejandra
    bluetui
    devenv
    dua
    dust
    fastfetch
    gitoxide
    httpie
    hyperfine
    jq
    lazydocker
    playerctl
    presenterm
    tldr
    tokei
    unzip
    wl-clipboard
    xh
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
    hclfmt
    markdownlint-cli2
    nixfmt-rfc-style

    # fonts
    font-awesome
    # powerline-fonts
    # powerline-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.zed-mono

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
