# modules/devshell.nix
# Development shell and pre-commit hooks using flake-parts perSystem
{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    self',
    ...
  }: {
    checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = inputs.self;
      hooks = {
        check-added-large-files.enable = true;
        check-yaml.enable = true;
        deadnix.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer.enable = true;
        alejandra.enable = true;
        trim-trailing-whitespace.enable = true;
      };
    };

    devShells.default = pkgs.mkShell {
      inherit (self'.checks.pre-commit-check) shellHook;
      buildInputs = self'.checks.pre-commit-check.enabledPackages;

      packages = with pkgs; [
        # tools
        cachix
        just
        nh
        nixfmt
        sops
        yq-go
        # language server
        alejandra
        nil
        yaml-language-server
      ];
    };
  };
}
