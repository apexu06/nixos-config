{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de.name == "niri") {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    programs = {
      niri = {
        enable = true;
        package = pkgs.niri;
      };
      gnome-disks.enable = true;
    };

    security = {
      polkit.enable = true;
      pam.services.greetd.enableGnomeKeyring = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };
  };
}
