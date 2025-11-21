{
  settings,
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../app/launcher/${settings.launcher}.nix
    ../hypridle.nix
    ../hyprlock.nix
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    config = builtins.readFile ./config.kdl;
    package = pkgs.niri;
  };

  # home.file.".config/niri/config.kdl".text =
  #   builtins.readFile ./config.kdl
  #   + ''
  #     cursor {
  #       xcursor-theme "Adwaita"
  #       xcursor-size ${toString (config.stylix.cursor.size - 10)}
  #     }
  #   '';

  home.packages = with pkgs; [
    nwg-look
    pavucontrol
    hyprpicker
    wlogout
    nautilus
    eog
    papers
    adwaita-icon-theme
    gnome-disk-utility
  ];

  services = {
    polkit-gnome.enable = true;
    udiskie = {
      enable = true;
      automount = true;
    };

    swww = {
      enable = true;
    };
  };

  home.activation.wallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.swww}/bin/swww img "${config.stylix.image}" \
      --transition-type grow \
      --transition-angle 45 \
      --transition-duration 1
  '';
}
