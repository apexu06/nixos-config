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
