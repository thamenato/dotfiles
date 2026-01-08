{
  imports = [
    ./packages.nix
    ./programs
    ./services.nix
    ./xdg.nix
  ];

  targets.genericLinux = {
    enable = true;
    gpu.enable = true;
  };

  home = {
    sessionVariables = {
      BROWSER = "zen";
    };
  };
}
