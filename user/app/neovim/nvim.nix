{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lua-language-server
    nil
    typescript-language-server
    stdenv.cc
    python313Packages.python-lsp-server
    bash-language-server
    prettier
    prettierd
    stylua
    alejandra
    ruff
    tree-sitter
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home.file.".config/nvim/lua/theme_choice.lua".text = ''return "${config.settings.theme}"'';

  home.file.".config/nvim".source = ./lazy;
  home.file.".config/nvim".recursive = true;
}
