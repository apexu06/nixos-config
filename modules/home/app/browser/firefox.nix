{...}: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "browser.startup.page" = 3;
      };
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@nos"];
          };

          "My NixOS" = {
            urls = [
              {
                template = "https://mynixos.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@mos"];
          };
        };
      };
    };

    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      HardwareAcceleration = true;
      OfferToSaveLogins = false;
      DontCheckDefaultBrowser = true;
    };
  };
}
