{ pkgs, settings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./stylix.nix
    ./pipewire.nix
    ./virtualization.nix
    ./de/${settings.de}.nix
    ./steam.nix
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
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
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
  };

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
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
