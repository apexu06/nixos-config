{
  pkgs,
  inputs,
  theme,
  ...
}: let
  themeFile = builtins.toPath ../../theme/${theme}/theme.yaml;
in {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = themeFile;
    targets.waybar.font = "serif";

    targets.fish.enable = false;
    targets.zed.enable = false;
    targets.foot.fonts.enable = false;
    targets.emacs.enable = false;
    targets.zen-browser.enable = false;
    targets.obsidian.enable = false;

    targets.qt = {
      enable = true;
      standardDialogs = "xdgdesktopportal";
    };

    targets.neovim = {
      plugin = "mini.base16";
      enable = false;
      transparentBackground = {
        numberLine = true;
        main = true;
        signColumn = true;
      };
    };

    targets.firefox = {
      enable = true;
      firefoxGnomeTheme.enable = true;
      profileNames = ["default"];
    };

    fonts = {
      serif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      monospace = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 12;
        applications = 12;
        desktop = 13;
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus";
      light = "Papirus";
    };

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
    };

    opacity = {
      terminal = 1.0;
      desktop = 0.7;
      applications = 0.8;
    };
  };
}
