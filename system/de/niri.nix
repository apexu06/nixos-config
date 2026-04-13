{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de.name == "niri") {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    programs = {
      niri.enable = true;
      gnome-disks.enable = true;
    };

    security = {
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    services = {
      gnome.gnome-keyring.enable = true;
      greetd = {
        enable = true;
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
