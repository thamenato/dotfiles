# modules/home/packages.nix
# Common packages shared by all hosts
{...}: {
  flake.homeModules.packages = {pkgs, ...}: {
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
      tlp
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
      bruno

      # lsp
      ansible-lint
      bash-language-server
      cuelsp
      docker-compose-language-service
      gopls
      marksman
      nil
      nixd
      ruff
      superhtml
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
    ];
  };
}
