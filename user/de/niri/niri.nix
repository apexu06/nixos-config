{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
    ../hypridle.nix
    ../hyprlock.nix
    ../../launcher/launcher.nix
  ];

  config = lib.mkIf (config.settings.de.name == "niri") {
    home.packages = with pkgs;
      [
        nwg-look
        pavucontrol
        hyprpicker
        nautilus
        eog
        adwaita-icon-theme
        gnome-disk-utility
      ]
      ++ lib.optionals (config.settings.de.shell != "noctalia")
      [
        wlogout
      ];

    services = {
      polkit-gnome.enable = true;
      udiskie = {
        enable = true;
        automount = true;
      };

      hyprpaper = {
        enable = true;
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "caps:escape";
              variant = "altgr-intl";
            };
            repeat-delay = 175;
            track-layout = "global";
          };

          touchpad = {
            tap = true;
            natural-scroll = true;
          };

          warp-mouse-to-focus.enable = true;
          focus-follows-mouse = {
            enable = true;
            # max-scroll-amount = "0%";
          };
        };

        cursor = {
          theme = config.stylix.cursor.name;
          size = config.stylix.cursor.size - 10;
        };

        # Output configuration
        outputs = {
          "DP-3" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 180.0;
            };
            scale = 1.0;
            position = {
              x = 0;
              y = 0;
            };
          };

          "HDMI-A-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 71.910;
            };
            scale = 1.0;
            position = {
              x = -1920;
              y = -35;
            };
          };

          "eDP-1" = {
            mode = {
              width = 2880;
              height = 1920;
              refresh = 120.0;
            };
            variable-refresh-rate = true;
            scale = 1.5;
            position = {
              x = 0;
              y = 0;
            };
          };
        };

        # Layout configuration
        layout = {
          gaps = 8;
          center-focused-column = "never";
          always-center-single-column = true;
          background-color = "transparent";

          preset-column-widths = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
            {proportion = 1.0;}
          ];

          default-column-width = {proportion = 0.5;};

          border = {
            enable = false;
            width = 4;
            active.color = "#ffc87f";
            inactive.color = "#505050";
          };

          focus-ring = {
            enable = true;
            width = 2;
            active.color = config.lib.stylix.colors.base0D;
          };

          shadow = {
            enable = true;
            softness = 30.0;
            spread = 5.0;
            offset = {
              x = 0;
              y = 0;
            };
            color = "#0007";
          };
        };

        # Startup commands
        spawn-at-startup =
          [
            {command = ["sh" "-c" "wl-paste --type text --watch cliphist store"];}
            {command = ["sh" "-c" "wl-paste --type image --watch cliphist store"];}
          ]
          ++ lib.optionals (config.settings.de.shell == "noctalia") [
            {command = ["noctalia-shell"];}
          ];

        # General settings
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        # Window rules
        window-rules = [
          {
            matches = [
              {title = "(unset)";}
              {app-id = "^jetbrains-.*";}
              {is-floating = true;}
            ];
            default-floating-position = {
              relative-to = "top";
              x = 0;
              y = 100;
            };
            default-window-height = {proportion = 0.4;};
            default-column-width = {proportion = 0.3;};
          }
          {
            matches = [
              {app-id = "^org\\.wezfurlong\\.wezterm$";}
            ];
            default-column-width = {proportion = 0.5;};
          }
          {
            matches = [
              {app-id = "steam";}
              {title = ''r#"^notificationtoasts_\d+_desktop$"#'';}
            ];
            default-floating-position = {
              x = 10;
              y = 10;
              relative-to = "bottom-right";
            };
          }
          {
            geometry-corner-radius = {
              bottom-left = 12.0;
              bottom-right = 12.0;
              top-left = 12.0;
              top-right = 12.0;
            };
            clip-to-geometry = true;
          }
          # {
          #   matches = [
          #     {is-active = false;}
          #   ];
          #   opacity = 0.98;
          # }
        ];

        # Layer rules
        layer-rules = [
          {
            matches = [
              {namespace = "^hyprpaper$";}
              {namespace = "^noctalia-overview*";}
            ];
            place-within-backdrop = true;
          }
        ];

        # Keybindings
        binds = with config.lib.niri.actions;
          lib.mkMerge [
            {
              "Mod+Shift+Slash".action = show-hotkey-overlay;

              "Mod+Return".action = spawn config.settings.terminal.emulator;
              "Mod+Shift+Return".action = spawn config.settings.terminal.emulator "-e" "yazi";

              "Mod+Alt+L".action = spawn "hyprlock";
              "Mod+Shift+M".action = spawn "wlogout";
              "Mod+Shift+C".action = spawn "sh" "-c" "hyprpicker -a";
              "Mod+O".action = toggle-overview;
              "Mod+BackSpace".action = close-window;
              "Print".action.screenshot = [];
              # "Ctrl+Print".action = screenshot-screen;
              "Alt+Print".action.screenshot-window = [];
              "Mod+Shift+Q".action = quit;
              "Ctrl+Alt+Delete".action = quit;
              "Mod+Shift+S".action = spawn "qs" "-c" "bar" "ipc" "call" "recorder" "ipcSaveReplay";
              "Mod+Shift+U".action = spawn "qs" "-c" "bar" "ipc" "call" "recorder" "ipcToggleReplay";

              # Audio controls
              "XF86AudioRaiseVolume" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
              };
              "XF86AudioLowerVolume" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              };
              "XF86AudioMute" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };
              "XF86AudioMicMute" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };

              # Media controls
              "XF86AudioPlay" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "playerctl play-pause";
              };
              "XF86AudioStop" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "playerctl stop";
              };
              "XF86AudioPrev" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "playerctl previous";
              };
              "XF86AudioNext" = {
                allow-when-locked = true;
                action = spawn "sh" "-c" "playerctl next";
              };

              # Brightness controls
              "XF86MonBrightnessUp" = {
                allow-when-locked = true;
                action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
              };
              "XF86MonBrightnessDown" = {
                allow-when-locked = true;
                action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
              };

              # Focus navigation
              "Mod+Left".action = focus-column-left;
              "Mod+Down".action = focus-window-down;
              "Mod+Up".action = focus-window-up;
              "Mod+Right".action = focus-column-right;
              "Mod+H".action = focus-column-left;
              "Mod+J".action = focus-window-down;
              "Mod+K".action = focus-window-up;
              "Mod+L".action = focus-column-right;

              # Move windows/columns
              "Mod+Ctrl+Left".action = move-column-left;
              "Mod+Ctrl+Down".action = move-window-down;
              "Mod+Ctrl+Up".action = move-window-up;
              "Mod+Ctrl+Right".action = move-column-right;
              "Mod+Ctrl+H".action = move-column-left;
              "Mod+Ctrl+J".action = move-window-down;
              "Mod+Ctrl+K".action = move-window-up;
              "Mod+Ctrl+L".action = move-column-right;

              # Column positioning
              "Mod+Home".action = focus-column-first;
              "Mod+End".action = focus-column-last;
              "Mod+Ctrl+Home".action = move-column-to-first;
              "Mod+Ctrl+End".action = move-column-to-last;

              # Monitor navigation
              "Mod+Shift+Left".action = focus-monitor-left;
              "Mod+Shift+Down".action = focus-monitor-down;
              "Mod+Shift+Up".action = focus-monitor-up;
              "Mod+Shift+Right".action = focus-monitor-right;
              "Mod+Shift+H".action = focus-monitor-left;
              "Mod+Shift+L".action = focus-monitor-right;

              # Move column to monitor
              "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
              "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
              "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
              "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
              "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
              "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
              "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
              "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

              # Workspace navigation
              "Mod+Page_Down".action = focus-workspace-down;
              "Mod+Page_Up".action = focus-workspace-up;
              "Mod+Shift+J".action = focus-workspace-down;
              "Mod+Shift+K".action = focus-workspace-up;
              "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
              "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
              "Mod+Ctrl+U".action = move-column-to-workspace-down;
              "Mod+Ctrl+I".action = move-column-to-workspace-up;

              # Move workspace
              "Mod+Shift+Page_Down".action = move-workspace-down;
              "Mod+Shift+Page_Up".action = move-workspace-up;
              # "Mod+Shift+U".action = move-workspace-down;
              "Mod+Shift+I".action = move-workspace-up;

              # Wheel scroll bindings
              "Mod+WheelScrollDown" = {
                cooldown-ms = 150;
                action = focus-workspace-down;
              };
              "Mod+WheelScrollUp" = {
                cooldown-ms = 150;
                action = focus-workspace-up;
              };
              "Mod+Ctrl+WheelScrollDown" = {
                cooldown-ms = 150;
                action = move-column-to-workspace-down;
              };
              "Mod+Ctrl+WheelScrollUp" = {
                cooldown-ms = 150;
                action = move-column-to-workspace-up;
              };

              "Mod+WheelScrollRight".action = focus-column-right;
              "Mod+WheelScrollLeft".action = focus-column-left;
              "Mod+Ctrl+WheelScrollRight".action = move-column-right;
              "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

              "Mod+Shift+WheelScrollDown".action = focus-column-right;
              "Mod+Shift+WheelScrollUp".action = focus-column-left;
              "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
              "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

              # Numbered workspaces
              "Mod+1".action = focus-workspace 1;
              "Mod+2".action = focus-workspace 2;
              "Mod+3".action = focus-workspace 3;
              "Mod+4".action = focus-workspace 4;
              "Mod+5".action = focus-workspace 5;
              "Mod+6".action = focus-workspace 6;
              "Mod+7".action = focus-workspace 7;
              "Mod+8".action = focus-workspace 8;
              "Mod+9".action = focus-workspace 9;

              # Using list format for move-column-to-workspace to work around issue #944
              "Mod+Shift+1".action.move-column-to-workspace = [1];
              "Mod+Shift+2".action.move-column-to-workspace = [2];
              "Mod+Shift+3".action.move-column-to-workspace = [3];
              "Mod+Shift+4".action.move-column-to-workspace = [4];
              "Mod+Shift+5".action.move-column-to-workspace = [5];
              "Mod+Shift+6".action.move-column-to-workspace = [6];
              "Mod+Shift+7".action.move-column-to-workspace = [7];
              "Mod+Shift+8".action.move-column-to-workspace = [8];
              "Mod+Shift+9".action.move-column-to-workspace = [9];

              # Column operations
              "Mod+BracketLeft".action = consume-or-expel-window-left;
              "Mod+BracketRight".action = consume-or-expel-window-right;
              "Mod+Comma".action = consume-window-into-column;
              "Mod+Period".action = expel-window-from-column;

              # Window sizing
              "Mod+N".action = switch-preset-column-width;
              "Mod+Shift+N".action = switch-preset-column-width-back;
              "Mod+Shift+R".action = switch-preset-window-height;
              "Mod+Ctrl+R".action = reset-window-height;
              "Mod+M".action = maximize-column;
              "Mod+F".action = fullscreen-window;
              "Mod+Ctrl+F".action = expand-column-to-available-width;
              "Mod+C".action = center-column;
              "Mod+Ctrl+C".action = center-visible-columns;

              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Equal".action = set-column-width "+10%";
              "Mod+Shift+Minus".action = set-window-height "-10%";
              "Mod+Shift+Equal".action = set-window-height "+10%";

              # Floating windows
              "Mod+V".action = toggle-window-floating;
              "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

              # Tabbed display
              "Mod+W".action = toggle-column-tabbed-display;

              # Layout switching
              "Mod+Space".action = switch-layout "next";
              "Mod+Shift+Space".action = switch-layout "prev";

              # Toggle shortcuts inhibit
              "Mod+Escape" = {
                allow-inhibiting = false;
                action = toggle-keyboard-shortcuts-inhibit;
              };
            }

            (lib.mkIf (config.settings.de.launcher != "noctalia") {
              "Mod+P".action = spawn config.app.launcher.command;
            })
          ];
      };
    };
  };
}
