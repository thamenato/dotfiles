{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = "firefox.desktop";
          text = "org.gnome.TextEditor.desktop";
        in
        {
          "text/html" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/unknown" = browser;
          "text/markdown" = text;
        };
    };
    desktopEntries = {
      # list of .desktop files
      # ls -l /run/current-system/sw/share/applications

      # Example of new entry:
      # librewolf = {
      #   name = "LibreWolf";
      #   exec = "${pkgs.librewolf}/bin/librewolf";
      # };
    };
  };
}
