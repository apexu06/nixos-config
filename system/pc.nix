{pkgs, ...}: {
  imports = [
    ./configuration.nix
    ./services.nix
    ./virtualization.nix
    ./podman.nix
    ./hardware/pc-hardware-configuration.nix
    ./boot/lanzaboote.nix
  ];
  environment.systemPackages = with pkgs; [
    ntfs3g
    sbctl
    android-tools
    ddcutil

    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    docker-compose
    podman-tui
  ];

  networking.hostName = "nixp";

  programs.gpu-screen-recorder.enable = true;

  fileSystems."/mnt/nvme0" = {
    device = "/dev/disk/by-uuid/8A7AECD97AECC355";
    fsType = "ntfs";
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
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };

  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope.overrideAttrs (_: {
      NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
    });
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
      libXcursor
      libXi
      libXinerama
      libXScrnSaver
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
  hardware.i2c.enable = true;
}
