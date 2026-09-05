{pkgs, ...}: {
  home.file.".config/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME
    env=TERMCMD=kitty
    env=PATH="$PATH:/run/current-system/sw/bin"
    open_mode = suggested
    save_mode = last
  '';

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
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        common = {
          default = "gnome";

          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
        };
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/html" = "firefox.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
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
