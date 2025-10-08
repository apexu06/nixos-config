{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  programs.ags = {
    enable = true;
    configDir = ./ags-bar;

    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.battery
      inputs.astal.packages.${pkgs.system}.network
      inputs.astal.packages.${pkgs.system}.tray
      inputs.astal.packages.${pkgs.system}.powerprofiles
      inputs.astal.packages.${pkgs.system}.io
      inputs.astal.packages.${pkgs.system}.bluetooth
      inputs.astal.packages.${pkgs.system}.hyprland
      inputs.astal.packages.${pkgs.system}.wireplumber
      inputs.astal.packages.${pkgs.system}.apps
      inputs.astal.packages.${pkgs.system}.cava
      inputs.astal.packages.${pkgs.system}.mpris
      fzf
    ];
  };

  systemd.user.services.ags = {
    unit = {
      description = "ags-bar";
      after = [ "graphical-session.target" ];
      partof = [ "graphical-session.target" ];
    };
    service = {
      execstart = "${pkgs.ags}/bin/ags run";
      restart = "always";
    };
    install = {
      wantedby = [ "graphical-session.target" ];
    };
  };
}
