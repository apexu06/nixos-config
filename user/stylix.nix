{
  pkgs,
  apple-fonts,
  inputs,
  settings,
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

}
