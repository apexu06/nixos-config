{
  pkgs,
  settings,
  lib,
  inputs,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de == "hyprland") {
    imports =
      [
        ../hypridle.nix
      ]
      ++ lib.optionals (config.settings.de-shell != "noctalia")
      [
        ../hyprlock.nix
      ]
      ++ lib.optionals (config.settings.launcher != "noctalia")
      [
        ../../launcher/launcher.nix
      ];

    home.packages = with pkgs;
      [
        nwg-look
        pavucontrol
        hyprshot
        hyprpicker
        nautilus
        eog
        adwaita-icon-theme
        gnome-disk-utility
      ]
      ++ lib.optionals (settings.de-shell != "noctalia")
      [
        wlogout
      ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      systemd.variables = ["--all"];
      extraConfig =
        ''
          $drun = ${
            if settings.launcher == "tofi"
            then "tofi-drun --drun-launch=true"
            else "noctalia-shell ipc call launcher toggle"
          }
          $screenshot = hyprshot -m region -o "$HOME/Pictures/"
          $lockscreen = hyprlock
        ''
        + builtins.readFile ./hyprland.conf;
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
