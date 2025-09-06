{ pkgs, ... }:

let
  isVM =
    (builtins.readFile (
      pkgs.runCommand "detect-vm" { } ''
        ${pkgs.systemd}/bin/systemd-detect-virt --vm > $out || echo "none" > $out
      ''
    )) != "none\n";
in
{
  services = {
    displayManager = {
      enable = true;
      gdm.enable = false;
    };
  };

  services.xserver.displayManager.lightdm.enable = false;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    hyprlock.enable = true;
  };

  security = {
    pam.services.swaylock = { };
    pam.services.hyprlock = { };
    pam.services.hyprland.enable = true;
  };

  environment.sessionVariables =
    if isVM then
      {
        LIBGL_ALWAYS_SOFTWARE = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      }
    else
      { };
}
