{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  config = lib.mkIf (config.settings.de.name == "kde") {
    programs.plasma = {
      enable = true;

      hotkeys.commands."launch-kitty" = {
        name = "Launch Kitty";
        key = "Meta+Enter";
        command = "kitty";
      };

      shortcuts = {
        ksmserver = {
          "Lock Session" = [
            "Screensaver"
            "Meta+Alt+L"
          ];
        };

        kwin = {
          "Expose" = "Meta+,";
          "Switch Window Down" = "Meta+J";
          "Switch Window Left" = "Meta+H";
          "Switch Window Right" = "Meta+L";
          "Switch Window Up" = "Meta+K";
        };
      };
    };
  };
}
