{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de == "gnome") {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      gvfs.enable = true;
    };
  };
}
