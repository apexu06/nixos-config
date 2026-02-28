{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
    pam.services.hyprland.enable = true;
    pam.services.hyprland.enableGnomeKeyring = true;
  };
}
