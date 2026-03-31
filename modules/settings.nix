{lib, ...}: {
  options.settings = {
    de = lib.mkOption {
      type = lib.types.enum ["niri" "hyprland" "gnome" "mango"];
      default = "niri";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "tokyonight";
    };

    useWallpaper = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    launcher = lib.mkOption {
      type = lib.types.str;
      default = "noctalia";
    };
    de-shell = lib.mkOption {
      type = lib.types.str;
      default = "noctalia";
    };
    terminal = lib.mkOption {
      type = lib.types.enum ["kitty" "foot" "wezterm"];
      default = "kitty";
    };
  };
}
