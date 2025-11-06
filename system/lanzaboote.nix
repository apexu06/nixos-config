{
  pkgs,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
