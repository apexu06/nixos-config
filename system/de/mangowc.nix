{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.mango.nixosModules.mango
  ];

  config = lib.mkIf (config.settings.de.name == "mango") {
    programs.mango.enable = true;
  };
}
