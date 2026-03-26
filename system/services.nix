{
  pkgs,
  config,
  ...
}: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
  };
in {
  environment.systemPackages = [sddm-astronaut];

  services = {
    flatpak.enable = true;
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

    displayManager = {
      enable = true;
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;

        wayland.enable = true;
        enableHidpi = true;

        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
          };
          Fonts = {
            Font = config.stylix.fonts.serif.name;
            BoldFont = config.stylix.fonts.serif.name;
          };
        };
        theme = "sddm-astronaut-theme";
        extraPackages = [sddm-astronaut];
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
  };
}
