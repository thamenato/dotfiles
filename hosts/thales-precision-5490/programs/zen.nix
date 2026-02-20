{config, ...}: {
  programs.zen-browser = let
    # extensions: https://github.com/0xc000022070/zen-browser-flake?tab=readme-ov-file#extensions
    mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    });
  in {
    enable = true;
    # Enabled Zen Mods:
    # - Animations Plus
    # - Better Active Tab
    # - Better Unloaded Tabs
    # - Cleaned URL bar
    # - Lean
    # - No Gaps
    # - SuperPins

    policies = {
      ExtensionSettings = mkExtensionSettings {
        "null" = "1password-x-password-manager";
      };
    };

    profiles."default" = {
      containersForce = true;
      containers = {
        "Work" = {
          color = "green";
          icon = "briefcase";
          id = 2;
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."default".containers;
      in {
        "Work" = {
          id = "61890944-4b85-438a-a4fc-c044f71bc9e7";
          container = containers."Work".id;
          position = 2000;
        };
      };
    };
  };
}
