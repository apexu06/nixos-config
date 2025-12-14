{
  lib,
  settings,
  ...
}: let
  commandFor = backend:
    if backend == "vicinae"
    then ["vicinae" "toggle"]
    else if backend == "fuzzel"
    then ["fuzzel"]
    else if backend == "anyrun"
    then ["anyrun"]
    else if backend == "tofi"
    then ["tofi" "-show" "drun"]
    else throw "Unknown launcher backend: ${backend}";
in {
  imports = [
    ./${settings.launcher}.nix
  ];

  options.app.launcher = {
    command = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = commandFor settings.launcher;
      description = "Launcher command used by configs.";
    };
  };
}
