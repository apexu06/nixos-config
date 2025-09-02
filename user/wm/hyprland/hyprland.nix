{ pkgs, ... }:
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    fuzzel
    polkit_gnome
    swww
    hypridle
    hyprpicker
    hyprlock
    xdg-desktop-portal-hyprland
    wlogout
    firefox
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
