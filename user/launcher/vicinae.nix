{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      keybinding = "emacs";
      search_files_in_root = true;
      font = {
        normal = {
          size = 12;
        };
      };
      theme = {
        dark = {
          name = "stylix";
          icon_theme = "auto";
        };
      };
      launcher_window = {
        opacity = 1;
      };
      providers = {
        applications = {
          entrypoints = {
            "ARC Raiders" = {
              enabled = false;
            };
            Absolum = {
              enabled = false;
            };
            kvantummanager = {
              enabled = false;
            };
            nixos-manual = {
              enabled = false;
            };
            vicinae = {
              enabled = false;
            };
            xterm = {
              enabled = false;
            };
          };
        };
        core = {
          enabled = false;
        };
        developer = {
          enabled = false;
        };
        files = {
          entrypoints = {
            search = {
              alias = "f";
            };
          };
        };
        font = {
          enabled = false;
        };
        raycast-compat = {
          enabled = false;
        };
        theme = {
          enabled = false;
        };
        wm = {
          entrypoints = {
            switch-windows = {
              alias = "w";
            };
          };
        };
      };
    };
  };
}
