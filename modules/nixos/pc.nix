{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
    ./services.nix
    ./virtualization.nix
    ./podman.nix
    ./hardware/pc-hardware-configuration.nix
    ./boot/lanzaboote.nix
    ./ollama.nix
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
    neededForBoot = false;
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
    neededForBoot = false;
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

  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [canon-cups-ufr2];
    };
  };

  hardware.printers.ensurePrinters = [
    {
      name = "Canon_LBP622C";
      location = "Home";
      deviceUri = "dnssd://Canon%20LBP622C%2F623C%20(a0%3A59%3A30)%20(3)%20(a0%3A59%3A30)%20(2)%20(a0%20(a0%3A59%3A30)._ipp._tcp.local/?uuid=6d4ff0ce-6b11-11d8-8020-349f7ba233ec";
      model = "CNRCUPSLBP622CZS.ppd";
      ppdOptions = {
        PageSize = "A4";
      };
    }
  ];

  services.greetd.settings = {
    initial_session = {
      command = "niri-session";
      user = "apexu";
    };
  };
}
