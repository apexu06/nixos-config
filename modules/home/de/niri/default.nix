{pkgs, ...}: {
  home.packages = with pkgs; [
    nwg-look
    pavucontrol
    hyprpicker
    alacritty
    eog
    adwaita-icon-theme
    gnome-disk-utility
    udiskie
  ];

  services = {
    polkit-gnome.enable = true;

    hyprpaper = {
      enable = true;
    };
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
