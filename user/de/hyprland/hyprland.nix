{
  pkgs,
  settings,
  lib,
  ...
}: {
  imports =
    [
      ../hypridle.nix
    ]
    ++ lib.optionals (settings.de-shell != "noctalia")
    [
      ../hyprlock.nix
    ]
    ++ lib.optionals (settings.launcher != "noctalia")
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
    systemd.variables = ["--all"];
    extraConfig =
      ''
        $drun = ${
          if settings.launcher == "tofi"
          then "tofi-drun --drun-launch=true"
          else "fuzzel"
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
}
