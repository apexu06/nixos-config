{pkgs, ...}: {
  services = {
    flatpak.enable = true;
    openssh.enable = true;
    locate.enable = true;
    fwupd.enable = true;
    protonmail-bridge.enable = true;

    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
          user = "greeter";
        };
      };
    };
  };
}
