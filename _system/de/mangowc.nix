{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.mango.nixosModules.mango
  ];

  config = lib.mkIf (config.settings.de.name == "mango") {
    programs.mango.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
          user = "greeter";
        };
      };
    };
  };
}
