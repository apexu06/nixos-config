{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.ags.homeManagerModules.default
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
      fzf
    ];
  };

  systemd.user.services.ags = {
    unit = {
      description = "aylur's gtk shell bar";
      after = [ "graphical-session.target" ];
      partof = [ "graphical-session.target" ];
    };
    service = {
      execstart = "${pkgs.ags}/bin/ags";
      restart = "always";
    };
    install = {
      wantedby = [ "graphical-session.target" ];
    };
  };
}
