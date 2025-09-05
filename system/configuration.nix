{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./stylix.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
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
    fish
    wayland
  ];

  services = {
    openssh.enable = true;
    displayManager.gdm.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };

    locate.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    dbus.packages = [ pkgs.dconf ];
  };

  programs = {
    fish.enable = true;
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
    pam.services.login.enableGnomeKeyring = true;
  };
}
