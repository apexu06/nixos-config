{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ags
  ];

  xdg.configFile."ags".source = ./ags-bar;

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
