{lib, ...}: {
  imports = [./default-settings.nix];

  options.settings = {
    name = lib.mkOption {
      type = lib.types.str;
    };

    de = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.enum ["niri" "hyprland" "gnome" "mango" "kde"];
            default = "niri";
          };

          shell = lib.mkOption {
            type = lib.types.enum ["noctalia" "dms" "quickshell" "ags" "none"];
            default = "noctalia";
          };

          useWallpaper = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };

          launcher = lib.mkOption {
            type = lib.types.enum ["noctalia" "fuzzel" "anyrun" "vicinae" "tofi" "none"];
            default = "noctalia";
          };
        };
      };

      default = {};
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "tokyonight";
    };

    terminal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          emulator = lib.mkOption {
            type = lib.types.enum ["kitty" "foot" "wezterm"];
            default = "kitty";
          };
          useTmux = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
      default = {};
    };
  };
}
