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

    # Extensions:
    # - Private Internet Access
    # - uBlock Origin
    # - AI Grammar Check
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true; # save webs for later reading
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = mkExtensionSettings {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "{3e4d2037-d300-4e95-859d-3cba866f46d3}" = "private-internet-access-ext";
        "uBlock0@raymondhill.net" = "ublock-origin";
        "languagetool-webextension@languagetool.org" = "languagetool";
      };
    };

    profiles."default" = {
      settings = {
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.enable-at-startup" = false;
        "zen.view.compact.hide-toolbar" = false;
        "zen.view.compact.toolbar-flash-popup" = false;
        "zen.view.use-single-toolbar" = false;
        "zen.view.window.scheme" = 0;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
      };
      containersForce = true;
      containers = {
        "Personal" = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."default".containers;
      in {
        "Personal" = {
          id = "787d0fd7-5d70-4dbc-801d-3dfae851658b";
          container = containers."Personal".id;
          position = 1000;
        };
      };
    };
  };
}
