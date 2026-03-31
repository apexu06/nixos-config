{
  lib,
  config,
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
    ./anyrun.nix
    ./fuzzel.nix
    ./tofi.nix
    ./vicinae.nix
  ];

  options.app.launcher = {
    command = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = commandFor config.settings.launcher;
      description = "Launcher command used by configs.";
    };
  };
}
