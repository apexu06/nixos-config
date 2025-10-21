{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ntfs3g
    sbctl
  ];

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote

  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  fileSystems."/mnt/nvme0" = {
    device = "/dev/disk/by-uuid/8A7AECD97AECC355";
    fsType = "ntfs-3g";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };

  fileSystems."/mnt/nvme1" = {
    device = "/dev/disk/by-uuid/2CDAE689DAE64F20";
    fsType = "ntfs-3g";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };
}
