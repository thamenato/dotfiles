# modules/home/xdg.nix
# Shared XDG configuration.
#
# Everything here is scoped to the non-NixOS hosts, where home-manager owns the
# session environment, mime associations and portals instead of the system
# configuration doing it.
{...}: {
  flake.homeModules.xdg = {
    config,
    lib,
    pkgs,
    ...
  }: {
    xdg = lib.mkIf config.targets.genericLinux.enable {
      configFile = {
        "environment.d/envvars.conf".text = ''
          PATH="$HOME/.nix-profile/bin:$PATH"
        '';

        # snapd-desktop-integration compares the GTK/icon/cursor theme names
        # that stylix writes against snaps named `gtk-theme-*` / `icon-theme-*`.
        # Ours (adw-gtk3, candy-icons, Bibata-Modern-Ice) aren't packaged as
        # snaps, so it logs "Missing theme snaps" and raises "Some required
        # themes are missing" on every login, with nothing in the store that
        # would satisfy it. Mask the unit the same way `systemctl --user mask`
        # does — a symlink to /dev/null.
        "systemd/user/snap.snapd-desktop-integration.snapd-desktop-integration.service".source =
          config.lib.file.mkOutOfStoreSymlink "/dev/null";
      };

      mimeApps = let
        browser = ["zen-beta.desktop"];
      in {
        enable = true;

        defaultApplications = {
          # Web — everything the browser should own, including local HTML
          # files (Signal used to steal text/html).
          "text/html" = browser;
          "application/xhtml+xml" = browser;
          "application/x-extension-htm" = browser;
          "application/x-extension-html" = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xhtml" = browser;
          "application/x-extension-xht" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/chrome" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/unknown" = browser;

          "image/png" = ["com.github.weclaw1.ImageRoll.desktop"];

          "x-scheme-handler/sgnl" = ["signal.desktop"];
          "x-scheme-handler/signalcaptcha" = ["signal.desktop"];
          "x-scheme-handler/slack" = ["slack.desktop"];
          "x-scheme-handler/bruno" = ["bruno.desktop"];
          "x-scheme-handler/claude-cli" = ["claude-code-url-handler.desktop"];

          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["libreoffice-writer.desktop"];
        };
      };

      portal = {
        enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    };
  };
}
