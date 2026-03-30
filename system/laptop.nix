{
  imports = [
    ./configuration.nix
    ./hardware/laptop-hardware-configuration.nix
    ./podman.nix
    ./boot/systemd-boot.nix
  ];
  networking.hostName = "nixl";

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
  };
}
