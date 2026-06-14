{lib, ...}: {
  settings = lib.mkDefault {
    name = "none";
    de = {
      name = "niri";
      launcher = "noctalia";
      shell = "noctalia";
      useWallpaper = true;
    };

    theme = "tokyonight";
    terminal = {
      emulator = "kitty";
      useTmux = false;
    };
  };
}
