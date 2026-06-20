{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.mango.hmModules.mango

    ../../launcher/launcher.nix
  ];

  config = lib.mkIf (config.settings.de.name == "mango") {
    wayland.windowManager.mango = {
      enable = true;
      settings =
        ''
          # see config.conf
        ''
        + builtins.readFile ./config.conf;
      autostart_sh = ''
        # see autostart.sh
        # Note: here no need to add shebang
      '';
    };

    services = {
      polkit-gnome.enable = true;
      udiskie = {
        enable = true;
        automount = true;
      };
    };
  };
}
