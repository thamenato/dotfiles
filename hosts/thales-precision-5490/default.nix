{
  config,
  pkgs,
  nixGL,
  ...
}: {
  imports = [
    ./dconf.nix
    ./gtk.nix
    # ./i3.nix
    ./programs
    ./services
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
      devbox
      gnome-tweaks
      nh
      signal-desktop
      slack
      spotify
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

    defaultWrapper = "nvidiaPrime";
  };

  wayland.windowManager.hyprland.package = config.lib.nixGL.wrap pkgs.hyprland;
}
