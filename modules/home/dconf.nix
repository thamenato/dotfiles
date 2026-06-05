# modules/home/dconf.nix
# dconf settings for GNOME applications
{...}: {
  flake.homeModules.dconf = {...}: {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "Sweet-Dark";
      };
    };
  };
}
