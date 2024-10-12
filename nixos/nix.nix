{ pkgs, ... }:
{
  # nix settings
  nix = {
    # package = pkgs.nixVersions.latest;
    # package = pkgs.nixVersions.nix_2_23;
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "thamenato"
        "thales"
      ];
      trusted-users = [
        "thamenato"
        "thales"
      ];
    };
    optimise.automatic = true;
  };

}
