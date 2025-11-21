{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs = {
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  services.gnome.gnome-keyring.enable = true;
}
