{pkgs, ...}: {
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
    pyload = {
      enable = true;
      port = 9666;
    };

    locate.enable = true;
    fprintd.enable = true;

    power-profiles-daemon.enable = true;
    fwupd.enable = true;
    gnome = {
      gnome-keyring.enable = true;
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

    udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
    '';

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
