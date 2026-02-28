{pkgs, ...}: {
  services = {
    flatpak.enable = true;
    openssh.enable = true;

    greetd = {
      enable = true;
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };
    pyload = {
      enable = true;
      port = 9666;
    };
    printing = {
      enable = true;
      drivers = [
        pkgs.canon-cups-ufr2
      ];
    };

    locate.enable = true;
    fprintd.enable = true;

    power-profiles-daemon.enable = true;
    fwupd.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
    protonmail-bridge.enable = true;
    gvfs.enable = true;
    upower = {
      enable = true;
      percentageLow = 20;
    };
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    # displayManager = {
    #   enable = true;
    #   gdm.enable = true;
    # };

    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
  };
  programs.regreet.enable = true;
}
