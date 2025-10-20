{
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
      };
    };

    profiles."default" = {
      containersForce = true;
      containers = {
        "Personal" = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
      };
    };
  };
}
