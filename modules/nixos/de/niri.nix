{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri;
    };
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    # greetd = {
    #   enable = true;
    #   useTextGreeter = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
    #       user = "greeter";
    #     };
    #   };
    # };
  };
}
