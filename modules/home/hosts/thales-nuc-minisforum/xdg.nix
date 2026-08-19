# modules/home/hosts/thales-nuc-minisforum/xdg.nix
{...}: {
  flake.homeModules."hosts/thales-nuc-minisforum/xdg" = {pkgs, ...}: {
    xdg = {
      configFile = {
        "environment.d/envvars.conf".text = ''
          PATH="$HOME/.nix-profile/bin:$PATH"
        '';
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
