{pkgs, ...}: {
  nix = {
    # package = pkgs.nixVersions.latest;
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "thamenato"
        "nmeusling"
      ];
      trusted-users = [
        "thamenato"
        "nmeusling"
      ];
      warn-dirty = false;
      substituters = [
        "https://hyprland.cachix.org"
        "https://ghostty.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };
    optimise.automatic = true;
  };
}
