{ pkgs, ... }:

{
  imports = [
    ./waybar.nix
    ./fuzzel.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    polkit_gnome
    nwg-look
    pavucontrol
    hypridle
    hyprlock
    hyprpicker
    swaylock-fancy
    wlogout
    nautilus
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    systemd.variables = [ "--all" ];
  };

  programs = {
    swaylock.enable = true;
    wofi.enable = true;
  };

  services = {
    polkit-gnome.enable = true;
  };
}
