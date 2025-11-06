{
  settings,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../app/launcher/${settings.launcher}.nix
    ../hypridle.nix
    ../hyprlock.nix
  ];

  # home.file.".config/niri/config.kdl".text =
  #   builtins.readFile ./config.kdl
  #   + ''
  #     cursor {
  #       xcursor-theme "${config.stylix.cursor.name}"
  #       xcursor-size "${toString config.stylix.cursor.size}"
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
