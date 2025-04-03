{
  pkgs,
  nixGL,
  ...
}: {
  imports = [
    ./dconf.nix
    ./gtk.nix
    ./programs
    ./services.nix
    ./wayland.nix
    ./xdg.nix
  ];

  targets.genericLinux.enable = true;

  home = {
    sessionVariables = {
      GTK_THEME = "Sweet-Dark";
      BROWSER = "zen";
    };

    packages = with pkgs; [
      _1password-cli
      _1password-gui
      arandr
      devbox
      image-roll
      nh
      pwvucontrol
      signal-desktop
      slack
      slurp
      spotify
      uv
      xfce.thunar
    ];

    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
    };
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  nixGL = {
    inherit (nixGL) packages;

    defaultWrapper = "mesa";
  };
}
