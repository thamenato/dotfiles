{
  imports = [
    ./nixgl.nix
    ./packages.nix
    ./programs
    ./services.nix
    ./xdg.nix
  ];

  targets.genericLinux.enable = true;

  home = {
    sessionVariables = {
      BROWSER = "zen";
    };

    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
    };
  };
}
