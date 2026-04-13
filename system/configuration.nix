{pkgs, ...}: {
  imports = [
    ./stylix.nix
    ./pipewire.nix
    ./de/hyprland.nix
    ./de/niri.nix
    ./de/gnome.nix
    ./de/mangowc.nix
    ./de/kde.nix
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

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

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

  system.stateVersion = "25.05";
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
      "video"
      "i2c"
    ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    nix-ld = {
      enable = true;
    };
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
