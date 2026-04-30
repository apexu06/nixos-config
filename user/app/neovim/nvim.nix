{
  pkgs,
  config,
  lib,
  ...
}: let
  nvimDir = "${config.home.homeDirectory}/.dotfiles/user/app/neovim";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = with pkgs; [
    lua-language-server
    typescript-language-server
    tailwindcss-language-server
    ty # python
    bash-language-server
    nil

    stdenv.cc
    prettier
    prettierd
    stylua
    alejandra
    ruff
    tree-sitter

    neovim
  ];

  # programs.neovim = {
  #   enable = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   defaultEditor = true;
  #   extraConfig = "";
  # };

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.NVIM_THEME = config.settings.theme;

  home.file = {
    ".config/nvim" = {
      source = link "${nvimDir}/lazy";
      recursive = true;
    };
  };
}
