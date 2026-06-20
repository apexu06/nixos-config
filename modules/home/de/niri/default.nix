{pkgs, ...}: {
  home.packages = with pkgs; [
    nwg-look
    pavucontrol
    hyprpicker
    alacritty
    nautilus
    eog
    adwaita-icon-theme
    gnome-disk-utility
  ];

  services = {
    polkit-gnome.enable = true;
    udiskie = {
      enable = true;
      automount = true;
    };

    hyprpaper = {
      enable = true;
    };
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
