{ pkgs, ... }:
{
  xdg = {
    configFile."electron-flags.conf".text = ''
      --ozone-platform=wayland
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
    '';

    configFile."spotify-flags.conf".text = ''
      --ozone-platform=wayland
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
    '';
    desktopEntries = {
      yazi = {
        name = "Yazi";
        noDisplay = true;
      };
      btop = {
        name = "btop++";
        noDisplay = true;
      };
      fish = {
        name = "fish";
        noDisplay = true;
      };
      vim = {
        name = "Vim";
        noDisplay = true;
      };
      gvim = {
        name = "GVim";
        noDisplay = true;
      };
      nvim = {
        name = "nvim";
        noDisplay = true;
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      desktop = null;
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

}
