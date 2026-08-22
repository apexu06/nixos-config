{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/stylix.nix
    ../../modules/nixos/ollama.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/boot/lanzaboote.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/gpu-screen-recorder-ui.nix

    ../../packages/gpu-screen-recorder-ui/module.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
    sbctl
    android-tools
    ddcutil
  ];

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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
    i2c.enable = true;
  };

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
    greetd.settings = {
      initial_session = {
        command = "niri-session";
        user = "jzep";
      };
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
}
