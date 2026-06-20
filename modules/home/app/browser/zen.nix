{inputs, ...}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles.default = {
      pinsForce = true;

      settings = {
        "zen.welcome-screen.seen" = true;
      };

      search = {
        force = true;
        default = "ddg";
      };

      pins = {
        "YouTube" = {
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://www.youtube.com/";
          isEssential = true;
          position = 101;
        };
        "ChatGPT" = {
          id = "8af62707-0722-4049-9801-bedced343333";
          url = "https://chatgpt.com/";
          isEssential = true;
          position = 102;
        };
        "Claude" = {
          id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
          url = "https://claude.ai/";
          isEssential = true;
          position = 103;
        };
      };
    };
  };
}
