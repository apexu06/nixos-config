{
  pkgs,
  theme,
  config,
  ...
}: let
  nvimDir = "${config.home.homeDirectory}/.dotfiles/modules/home/app/neovim";
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
    gdb
    lldb

    neovim
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.NVIM_THEME = theme;

  home.file = {
    ".config/nvim" = {
      source = link "${nvimDir}/lazy";
      recursive = true;
    };
  };
}
