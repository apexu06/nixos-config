{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs = {
    niri.enable = true;
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  services.gnome.gnome-keyring.enable = true;
}
