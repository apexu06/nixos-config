{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ntfs3g
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    sbctl
  ];

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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = true;
}
