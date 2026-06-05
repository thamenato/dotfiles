# modules/home/default.nix
# Defines all homeConfigurations
{
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  username = "thamenato";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Helper to read background files (migrated from utils.nix)
  mkReadFolder = dir: let
    fileList = builtins.readDir dir;
    mkFileAttr = name: type:
      if type == "regular"
      then "${dir}/${name}"
      else null;
  in
    pkgs.lib.filterAttrs (_name: value: value != null) (pkgs.lib.mapAttrs mkFileAttr fileList);

  # Helper for swaybg (migrated from utils.nix)
  mkSwaybg = outputs: {
    argv =
      [
        "${pkgs.swaybg}/bin/swaybg"
        "-m"
        "fill"
      ]
      ++ (pkgs.lib.concatMap (item: [
          "-o"
          item.output
          "-i"
          "${item.image}"
        ])
        outputs);
  };

  backgrounds = mkReadFolder ../../misc/backgrounds;

  # Creates a home configuration for a specific host
  mkHome = hostName:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs backgrounds;
        utils = {inherit mkSwaybg;};
      };

      modules = [
        # External modules from flake inputs
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        inputs.noctalia.homeModules.default
        inputs.nvf.homeManagerModules.default
        inputs.stylix.homeModules.stylix
        inputs.zen-browser.homeModules.beta

        # Base configuration (shared by all hosts)
        self.homeModules.base

        # Host-specific configuration
        self.homeModules."hosts/${hostName}"
      ];
    };
in {
  flake.homeConfigurations = {
    "${username}@kassogtha" = mkHome "kassogtha";
    "${username}@thales-precision-5490" = mkHome "thales-precision-5490";
    "${username}@ythogtha" = mkHome "ythogtha";
    "${username}@zoth-ommog" = mkHome "zoth-ommog";
  };
}
