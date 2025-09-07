{ pkgs, settings, ... }:

{
  imports = [
    ./waybar.nix
    ./dunst.nix
    (if settings.launcher == "tofi" then ../../app/launcher/tofi.nix else ../../app/launcher/fuzzel.nix)
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
    eog
    adwaita-icon-theme
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    extraConfig = ''
      $drun = ${if settings.launcher == "tofi" then "tofi-drun --drun-launch=true" else "fuzzel"}
    ''
    + builtins.readFile ./hyprland.conf;
  };

  programs = {
    swaylock.enable = true;
    wofi.enable = true;
  };

  services = {
    polkit-gnome.enable = true;
  };
}
