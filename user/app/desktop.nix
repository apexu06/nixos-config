{pkgs, ...}: {
  home.packages = with pkgs; [
    protonvpn-gui
  ];

  programs.thunderbird = {
    enable = true;
    profiles = {};
  };

  accounts.email.accounts = {
    "coolcrafter06@gmail.com" = {
      address = "coolcrafter06@gmail.com";
      primary = true;
      thunderbird.enable = true;
    };
  };

  programs.vesktop = {
    enable = false;
    settings = {
      staticTitle = true;
      clickTrayToShowHide = true;
    };
    vencord.settings = {
      notifications = {
        useNative = "always";
      };
      cloud = {
        authenticated = true;
        url = "https://api.vencord.dev/";
        settingsSync = true;
      };
      plugins = {
        AnonymiseFileNames.enabled = true;
        CallTimer.enabled = true;
        FixCodeBlockGap.enabled = true;
        FixYoutubeEmbeds.enabled = true;
        GameActivityToggle.enabled = true;
        IrcColors.enabled = true;
        OpenInApp.enabled = true;
        MessageClickActions.enabled = true;
        CrashHandler.enabled = true;
        WebKeybinds.enabled = true;
        SpotifyControls.enabled = true;
        SpotifyCrack.enabled = true;
        WebScreenShareFixes.enabled = true;
      };
    };
  };

  programs.zathura.enable = true;
}
