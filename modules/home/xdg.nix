{pkgs, ...}: {
  xdg = {
    autostart.enable = true;
    configFile."electron-flags.conf".text = ''
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
      setSessionVariables = true;
      templates = null;
      desktop = null;
      projects = null;
      publicShare = null;
    };

    portal = {
      enable = true;
      config.common.default = ["gnome"];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
      associations.removed = {
        "image/png" = "chromium-browser.desktop";
        "image/jpeg" = "chromium-browser.desktop";
        "image/webp" = "chromium-browser.desktop";
        "image/gif" = "chromium-browser.desktop";
      };
    };
  };
}
