{
  pkgs,
  lib,
  ...
}: {
  boot = {
    plymouth = {
      enable = true;
    };

    loader = {
      systemd-boot.enable = lib.mkForce false;

      grub = {
        enable = true;
        device = "nodev";
        fontSize = 28;
        font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
        useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

    kernelModules = ["btusb"];
  };
}
