{
  inputs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de == "mango") {
    imports = [
      inputs.mango.nixosModules.mango
    ];
    programs.mango.enable = true;
  };
}
