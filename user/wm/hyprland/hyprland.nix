{ pkgs, ... }:
{
  imports = [
    ./waybar.nix
    ./fuzzel.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    polkit_gnome
    nautilus
    hypridle
    hyprpicker
    swaylock-fancy
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wlogout
    firefox
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  programs = {
    swaylock.enable = true;
  };
}
