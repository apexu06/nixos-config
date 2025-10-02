{ pkgs, settings, ... }:

{
  imports = [
    ./waybar.nix
    (if settings.launcher == "tofi" then ../../app/launcher/tofi.nix else ../../app/launcher/fuzzel.nix)
    ./hypridle.nix
    ./hyprlock.nix
    ./dunst.nix
  ];

  home.packages = with pkgs; [
    polkit_gnome
    nwg-look
    qt6ct
    pavucontrol
    hypridle
    hyprlock
    hyprshot
    hyprpicker
    wlogout
    nautilus
    eog
    adwaita-icon-theme
    gnome-disk-utility
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    extraConfig = ''
      $drun = ${if settings.launcher == "tofi" then "tofi-drun --drun-launch=true" else "fuzzel"}
      $screenshot = hyprshot -m region -o "$HOME/Pictures/"
      $lockscreen = hyprlock
    ''
    + builtins.readFile ./hyprland.conf;
  };

  services = {
    polkit-gnome.enable = true;
  };
}
