{
  pkgs,
  inputs,
  lib,
  ...
}: {
  boot = {
    plymouth = {
      enable = true;
    };

    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = true;
    loader.grub.device = "nodev";
    loader.grub.useOSProber = true;
    loader.grub.efiSupport = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

    kernelModules = ["btusb"];
  };
}
