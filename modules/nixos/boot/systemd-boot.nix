{pkgs, ...}: {
  boot = {
    plymouth.enable = true;

    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };

    loader.efi.canTouchEfiVariables = true;
    kernelModules = ["btusb"];

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
