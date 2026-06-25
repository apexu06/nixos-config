{
  pkgs,
  inputs,
  config,
  profile,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    gpu-screen-recorder
    adwaita-icon-theme
  ];

  home.sessionVariables = {
    LOCK_CMD = "noctalia msg session lock";
    LAUNCHER_CMD = "noctalia msg panel-toggle launcher";
  };

  home.file.".config/noctalia/pam/password.conf".text = ''
    auth sufficient pam_fprintd.so max-tries=1
    auth required pam_unix.so
  '';

  programs.noctalia = {
    enable = true;
    package = lib.mkForce inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      audio = {
        enable_sounds = true;
      };

      hooks = {
        battery_charging = "noctalia msg power-set performance";
        battery_discharging = "noctalia msg power-set balanced";
      };

      backdrop = {
        blur_intensity = 0.0;
        tint_intensity = 0.59999998658895493;
      };

      idle = {
        behavior_order = ["dim-screen" "lock" "screen-off" "lock-and-suspend"];

        behavior.dim-screen = {
          enabled = true;
          action = "command";
          command = "brightnessctl set 10%";
          resume_command = "brightnessctl -r";
          timeout = 350;
        };

        behavior.lock = {
          enabled = true;
          action = "lock";
          timeout = 400;
        };

        behavior.screen-off = {
          enabled = true;
          action = "screen_off";
          timeout = 450;
        };

        behavior.lock-and-suspend = {
          enabled = true;
          action = "lock_and_suspend";
          timeout = 900;
        };
      };

      bar.widgets = let
        default_end = ["network" "bluetooth" "volume" "battery" "brightness" "tray" "control-center"];
        new_prefix =
          if profile == "pc"
          then ["ollama"]
          else [];
      in {
        background_opacity = config.stylix.opacity.desktop;
        center = ["clock" "media" "notifications"];
        end = new_prefix ++ default_end;
        font_family = "Adwaita Sans";
        margin_edge = 4;
        margin_ends = 350;
        padding = 10;
        radius = 80;
        scale = 1.1000000089406967;
        start = ["workspaces" "taskbar"];
        thickness = 32;
        widget_spacing = 8;
      };

      brightness = {
        enable_ddcutil = true;
      };

      control_center = {
        width = 750;
      };

      desktop_widgets = {
        schema_version = 1;
        widget_order = ["desktop-widget-0000000000000001" "desktop-widget-0000000000000002"];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "desktop-widget-0000000000000001" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1596.0;
            cy = 608.0;
            output = "HDMI-A-1";
            rotation = 0.0;
            type = "fancy_audio_visualizer";

            settings = {
              background = false;
              rotation_speed = 0.40000000000000002;
              visualization_mode = "wave_rings";
            };
          };

          "desktop-widget-0000000000000002" = {
            box_height = 160.0;
            box_width = 384.0;
            cx = 1600.0;
            cy = 892.0;
            output = "HDMI-A-1";
            rotation = 0.0;
            type = "media_player";

            settings = {
              background = false;
              color = "on_surface";
              hide_when_no_media = false;
              layout = "horizontal";
              shadow = true;
            };
          };
        };
      };

      dock = {
        auto_hide = true;
      };

      idle = {
        pre_action_fade_seconds = 5;
      };

      location = {
        auto_locate = true;
      };

      lockscreen = {
        allow_empty_password = true;
        blur_intensity = 0.39999999105930328;
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = ["lockscreen-login-box@HDMI-A-1" "lockscreen-login-box@DP-3" "lockscreen-widget-0000000000000001"];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "lockscreen-login-box@DP-3" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 1280.0;
            cy = 1321.0;
            output = "DP-3";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };

          "lockscreen-login-box@HDMI-A-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 960.0;
            cy = 961.0;
            output = "HDMI-A-1";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };

          "lockscreen-widget-0000000000000001" = {
            box_height = 400.0;
            box_width = 432.0;
            cx = 1280.0;
            cy = 720.0;
            output = "DP-3";
            rotation = 0.0;
            type = "clock";

            settings = {
              background = false;
              clock_style = "analog";
            };
          };
        };
      };

      keybinds = {
        down = ["Ctrl+n"];
        up = ["Ctrl+p"];
      };

      nightlight = {
        enabled = true;
      };

      notification = {
        position = "top_center";
      };

      plugins = {
        enabled = ["noctalia/screen_recorder"];
      };

      shell = {
        app_icon_color = "on_surface";
        font_family = config.stylix.fonts.sansSerif.name;
        screen_time_enabled = true;
        telemetry_enabled = false;
        ui_scale = 1.2000000104308128;

        panel = {
          launcher_categories = false;
          launcher_placement = "attached";
          session_placement = "centered";
        };
      };

      theme = {
        builtin = "Tokyo-Night";
        community_palette = "Tokyo Night Moon";
        mode = "dark";
        source = "custom";
        custom_palette = "stylix";

        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      wallpaper = {
        default = {
          path = config.stylix.image;
        };
        last = {
          path = "/home/jzep/Pictures/Wallpapers/wallpaper.jpg";
        };
        monitors = {
          "DP-3" = {
            path = config.stylix.image;
          };
          "HDMI-A-1" = {
            path = config.stylix.image;
          };
        };
      };

      widget = {
        brightness = {
          show_label = false;
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "on_hover";
        };
        network = {
          show_label = false;
        };
        spacer_2 = {
          length = 10;
          type = "spacer";
        };
        spacer_3 = {
          length = 10;
          type = "spacer";
        };
        ollama = {
          command = "systemctl start ollama && systemctl start open-webui";
          glyph = "robot";
          right_command = "systemctl stop ollama && systemctl stop open-webui";
          type = "custom_button";
        };
        taskbar = {
          only_active_workspace = true;
        };
        tray = {
          drawer = true;
          hidden = ["udiskie"];
          match_adjacent_spacing = true;
          pinned = [];
        };
        volume = {
          show_label = false;
        };
        workspaces = {
          hide_when_empty = true;
        };
      };
    };
  };
  home.file.".config/noctalia/palettes/stylix.json".text = ''
    {
      "dark": {
        "mPrimary": "#${colors.base0D}",
        "mOnPrimary": "#${colors.base00}",
        "mSecondary": "#${colors.base0E}",
        "mOnSecondary": "#${colors.base00}",
        "mTertiary": "#${colors.base0C}",
        "mOnTertiary": "#${colors.base00}",
        "mError": "#${colors.base08}",
        "mOnError": "#${colors.base00}",
        "mSurface": "#${colors.base00}",
        "mOnSurface": "#${colors.base05}",
        "mHover": "#${colors.base0C}",
        "mOnHover": "#${colors.base00}",
        "mSurfaceVariant": "#${colors.base01}",
        "mOnSurfaceVariant": "#${colors.base04}",
        "mOutline": "#${colors.base03}",
        "mShadow": "#${colors.base00}",
        "terminal": {
          "background": "#272822",
          "foreground": "#f8f8f2",
          "cursor": "#f8f8f2",
          "cursorText": "#272822",
          "selectionBg": "#f8f8f2",
          "selectionFg": "#272822",
          "normal": {
            "black": "#272822",
            "red": "#f92672",
            "green": "#a6e22e",
            "yellow": "#f4bf75",
            "blue": "#66d9ef",
            "magenta": "#ae81ff",
            "cyan": "#a1efe4",
            "white": "#f8f8f2"
          },
          "bright": {
            "black": "#75715e",
            "red": "#f92672",
            "green": "#a6e22e",
            "yellow": "#f4bf75",
            "blue": "#66d9ef",
            "magenta": "#ae81ff",
            "cyan": "#a1efe4",
            "white": "#f9f8f5"
          }
        }
      }
    }
  '';
}
