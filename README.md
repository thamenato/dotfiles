# dotfiles

![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)

My personal dotfiles using home-manager and nix.

## how to

Inside one of the `hosts` folder run the following command to rebuild the system

```shell
sudo nixos-rebuild switch --flake .
```

or to update home-manager

```shell
home-manager switch --flake .
```

## fresh install

* Install python first since dotbot requires it.
* Run `./install`
* Update `/etc/nixos/configuration.nix` to import the file `dotfiles-configuration.nix`
* `sudo nixos-rebuild switch`
