{
  imports = [
    ./configuration.nix
    ./hardware/laptop-hardware-configuration.nix
    ./podman.nix
    ./boot/systemd-boot.nix
    ./services.nix
  ];
  networking.hostName = "nixl";

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  security.pam = {
    howdy = {
      enable = true;
      control = "sufficient";
    };
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
