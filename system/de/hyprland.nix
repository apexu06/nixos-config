{pkgs, ...}: let
  isVM =
    (builtins.readFile (
      pkgs.runCommand "detect-vm" {} ''
        ${pkgs.systemd}/bin/systemd-detect-virt --vm > $out || echo "none" > $out
      ''
    ))
    != "none\n";
in {
  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    hyprlock.enable = true;
    gnome-disks.enable = true;
  };

  security = {
    pam.services.hyprlock = {};
    pam.services.hyprland.enable = true;
    pam.services.hyprland.enableGnomeKeyring = true;
  };

  # environment.sessionVariables =
  #   if isVM then
  #     {
  #       LIBGL_ALWAYS_SOFTWARE = "1";
  #       WLR_NO_HARDWARE_CURSORS = "1";
  #     }
  #   else
  #     { };
}
