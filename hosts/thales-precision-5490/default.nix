{
  config,
  pkgs,
  nixGL,
  ...
}: {
  imports = [
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
      devbox
      image-roll
      nh
      pwvucontrol
      (config.lib.nixGL.wrap satty)
      signal-desktop-bin
      # slack
      slurp
      # spotify
      sway-contrib.grimshot
      uv
      xfce.thunar
    ];

    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
      # ".config/niri/config.kdl".source = ./niri/config.kdl;
    };
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  nixGL = {
    inherit (nixGL) packages;

    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = ["mesa" "nvidiaPrime"];
  };
}
