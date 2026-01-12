{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal
    age
    alejandra
    argc
    bluetui
    devenv
    dua
    duf
    dust
    fastfetch
    gitoxide
    httpie
    hyperfine
    jq
    lazydocker
    playerctl
    presenterm
    swaybg
    tlrc
    tokei
    unzip
    wl-clipboard
    xh
    xxh
    zip

    # apps
    bitwarden-desktop
    vlc

    # lsp
    ansible-lint
    marksman
    nil
    nixd
    terraform-ls
    yaml-language-server

    # formatter/linter
    hclfmt
    markdownlint-cli2
    nixfmt

    # fonts
    # microsoft stuff
    corefonts
    vista-fonts

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
