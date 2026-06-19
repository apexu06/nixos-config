{}: {
  imports = [
    ./hardware-configuration.nix
  ];

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  services = {
    fprintd.enable = true;
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
    };

    howdy = {
      enable = true;
      settings = {
        video = {
          device_path = "/dev/video0";
        };
      };
    };
  };
}
