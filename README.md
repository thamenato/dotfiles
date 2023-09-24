# dotfiles

![built with nix][https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a]

My personal dotfiles using home-manager and nix.

## fresh install

* Install python first since dotbot requires it.
* Run `./install`
* Update `/etc/nixos/configuration.nix` to import the file `dotfiles-configuration.nix`
* `sudo nixos-rebuild switch`

