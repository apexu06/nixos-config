{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./stylix.nix
    ./pipewire.nix
    ./virtualization.nix
    ./de/${settings.de}.nix
    ./steam.nix
    ./lanzaboote.nix
    ./pc.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "apexu"
      ];
    };
    package = pkgs.lixPackageSets.stable.lix;
  };
  system.stateVersion = "25.05";

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "iusenixbtw"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  users.users.apexu = {
    isNormalUser = true;
    description = "apexu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    axel
    git
    wayland
    fish
    ntfs3g
  ];

  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };

    locate.enable = true;
    fprintd.enable = true;

    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    protonmail-bridge.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    displayManager = {
      enable = true;
      gdm.enable = true;
    };
  };

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };
}
