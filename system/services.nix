{
  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };

    locate.enable = true;
    fprintd.enable = true;

    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    protonmail-bridge.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    displayManager = {
      enable = true;
      gdm.enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
  };
}
