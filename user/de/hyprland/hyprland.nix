{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ../../launcher/${settings.launcher}.nix
    ../hypridle.nix
    ../hyprlock.nix
    ./dunst.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    pavucontrol
    hyprshot
    hyprpicker
    wlogout
    nautilus
    eog
    papers
    adwaita-icon-theme
    gnome-disk-utility
  ];

  wayland.windowManager.hyprland = {
    enable = true;
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
