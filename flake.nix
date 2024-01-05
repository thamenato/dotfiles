{
  description = "My Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    alejandra,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter = alejandra.defaultPackage.${system};

      devShells.default = pkgs.mkShell {
        packages = [
          # cli tools
          pkgs.alejandra
          pkgs.pre-commit
          pkgs.dpkg
          # python is required by dotbot
          pkgs.python3
          # language server
          pkgs.yaml-language-server
          pkgs.nil
        ];
      };
    });
}
