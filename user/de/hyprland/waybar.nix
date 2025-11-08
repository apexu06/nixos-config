{pkgs, ...}: {
  home.packages = with pkgs; [
    waybar
  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

    settings.main = {
      layer = "top";
      height = 10;
      position = "top";
      modules-left = [
        "niri/workspaces"
      ];
      modules-center = [
      ];
      modules-right = [
        "tray"
        "wireplumber"
        "backlight"
        "battery"
        "clock"
      ];
      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };
      "hyprland/window" = {
        max-length = 40;
      };
      keyboard-state = {
        numlock = true;
        capslock = true;
        format = "{name} {icon}";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };
      "hyprland/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };
      "hyprland/scratchpad" = {
        format = "{icon} {count}";
        show-empty = false;
        format-icons = [
          ""
          ""
        ];
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      tray = {
        icon-size = 21;
        spacing = 2;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%H:%M:%S}";
        format-alt = "{:%d/%m/%y}";
        interval = 1;
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = {
        format = " {}%";
        states = {
          warning = 80;
          critical = 90;
        };
        on-click = "hyprctl dispatch exec kitty btop";
      };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      backlight = {
        device = "amdgpu_bl2";
        format = "{icon} {percent}%";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
          " "
          " "
          " "
          " "
        ];
        smooth-scrolling-threshold = 2;
      };
      battery = {
        states = {
          full = 89;
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "{capacity}%";
        format-alt = "{time}";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
      };
      network = {
        format-wifi = "{icon}  {essid}";
        format-ethernet = " {ipaddr}/{cidr}";
        tooltip-format = "{essid} {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰤭 ";
        interval = 10;
        format-icons = {
          default = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
        };
        on-click = "networkmanager_dmenu";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        tooltip-format = "{volume}%";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-muted = "󰝟 ";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            " "
            "  "
          ];
        };
        on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
        on-click-right = "pavucontrol";
        max-volume = 150;
        scroll-step = {
        };
        smooth-scrolling-threshold = 2;
      };
      "custom/spotify-metadata" = {
        format = "{}";
        interval = 30;
        return-type = "json";
        exec = "~/.config/waybar/custom/spotify/metadata.sh";
        on-click = "~/.config/waybar/custom/spotify/controls.sh";
        on-scroll-up = "~/.config/waybar/custom/spotify/controls.sh next";
        on-scroll-down = "~/.config/waybar/custom/spotify/controls.sh previous";
        signal = 5;
        smooth-scrolling-threshold = 1;
      };
      "image#logo" = {
        path = "/home/apexu/.config/waybar/images/arch-logo.png";
        size = 32;
        on-click = "wlogout";
      };
      cava = {
        framerate = 60;
        autosens = 1;
        bars = 12;
        lower_cutoff_freq = 50;
        higher_cutoff_freq = 10000;
        method = "pipewire";
        source = "auto";
        stereo = true;
        reverse = false;
        bar_delimiter = 0;
        monstercat = true;
        waves = true;
        noise_reduction = {
        };
        input_delay = 2;
        sleep_timer = 0;
        hide_on_silence = true;
        format-icons = [
          " "
          "▁"
          "▂"
          "▃"
          "▄"
          "▅"
          "▆"
          "▇"
          "█"
        ];
        actions = {
          on-click-right = "mode";
        };
      };
    };
    style = ''
      * {
        font-size: 18px;
      }

      #custom-spotify-metadata {
        font-size: 16px;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0.2);
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      .modules-left #workspaces button.active {
        border: none;
      }

      button {
        border: none;
        outline: none;
        border-radius: 4px;
      }

      button:hover {
        background: inherit;
      }

      #workspaces {
        margin: 6px;
        border-radius: 12px;
        background-color: rgba(0, 0, 0, 0.4);
      }

      #workspaces button {
        font-weight: normal;
        padding: 4px 6px 2px 6px;
        color: white;
      }

      #workspaces button.active {
        padding: 4px 6px 5px 6px;
        color: @base0D;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      .modules-right {
        margin: 6px;
      }

      #clock,
      #battery,
      #cpu,
      #network,
      #wireplumber,
      #custom-spotify,
      #backlight,
      #memory,
      #tray {
        padding: 0px 14px 0px 14px;
        border-radius: 4px;
      }

      #tray {
        padding-right: 0px;
        margin-right: 0px;
      }

      #clock {
        min-width: 65px;
      }

      #custom-spotify-metadata {
        margin-right: 0px;
        padding-right: 8px;
      }

      #battery {
        /* background-color: @battery; */
      }

      #battery.charging {
      }

      #battery.critical:not(.charging) {
        background-color: @color1;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        box-shadow: 0px 0px 0px 0px @color1;
      }

      #custom-spotify:hover {
        color: red;
      }

      #tray {
        padding: 0px 8px 0px 8px;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }
    '';
  };
}
