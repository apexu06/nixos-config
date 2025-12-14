{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;

    settings = {
      closeOnFocusLoss = true;
      considerPreedit = false;
      faviconService = "google";
      font.size = 12;
      keybinding = "emacs";
      keybinds = {
      };
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = true;
      };
    };
  };
}
