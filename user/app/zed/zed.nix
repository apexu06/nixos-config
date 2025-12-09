{...}: {
  programs.zed-editor = {
    enable = true;
    mutableUserTasks = true;
    mutableUserSettings = true;
    mutableUserKeymaps = true;
    # userKeymaps = builtins.readFile ./keymap.json;
    # userSettings = builtins.readFile ./settings.json;
  };

  home.file.".config/zed/settings.json".text = builtins.readFile ./settings.json;
  home.file.".config/zed/keymap.json".text = builtins.readFile ./keymap.json;
}
