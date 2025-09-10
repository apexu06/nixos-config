{
  pkgs,
  apple-fonts,
  inputs,
  settings,
  config,
  ...
}:

let
  themePath = builtins.toPath ../theme/${settings.theme}/${settings.theme}.yaml;
  backgroundUrl = builtins.readFile ../theme/${settings.theme}/background-url.txt;
  backgroundHash = builtins.readFile ../theme/${settings.theme}/background-sha256.txt;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    base16Scheme = themePath;

    image = pkgs.fetchurl {
      url = backgroundUrl;
      hash = backgroundHash;
    };

    enable = true;
    autoEnable = true;

    targets.font-packages.enable = true;
    targets.fontconfig.enable = true;

    targets.waybar.font = "serif";
    targets.fish.enable = false;

    targets.neovim.plugin = "mini.base16";
    targets.neovim.enable = true;

    targets.zen-browser.profileNames = [ "default" ];

    fonts = {
      serif = {
        package = apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };

      sansSerif = {
        package = apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetbrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        desktop = 14;
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      name = "Catppuccin Mocha Dark";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 32;
    };

  };

  xdg.configFile."stylix/theme.css".text = ''
    :root {
      /* colors */
      --base00: #${config.lib.stylix.colors.base00};
      --base01: #${config.lib.stylix.colors.base01};
      --base02: #${config.lib.stylix.colors.base02};
      --base03: #${config.lib.stylix.colors.base03};
      --base04: #${config.lib.stylix.colors.base04};
      --base05: #${config.lib.stylix.colors.base05};
      --base06: #${config.lib.stylix.colors.base06};
      --base07: #${config.lib.stylix.colors.base07};
      --base08: #${config.lib.stylix.colors.base08};
      --base09: #${config.lib.stylix.colors.base09};
      --base0a: #${config.lib.stylix.colors.base0A};
      --base0b: #${config.lib.stylix.colors.base0B};
      --base0c: #${config.lib.stylix.colors.base0C};
      --base0d: #${config.lib.stylix.colors.base0D};
      --base0e: #${config.lib.stylix.colors.base0E};
      --base0f: #${config.lib.stylix.colors.base0F};

      /* font */
      --font-family: "${config.stylix.fonts.monospace.name}";
      --font-size: ${toString config.stylix.fonts.sizes.applications}px;
    }
  '';

}
