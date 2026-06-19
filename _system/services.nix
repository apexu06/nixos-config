{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    config.common.default = ["gnome"];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };
  services = {
    flatpak.enable = true;
    openssh.enable = true;
    locate.enable = true;
    fwupd.enable = true;
    protonmail-bridge.enable = true;

    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
  };
}
