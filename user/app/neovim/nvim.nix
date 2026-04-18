{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lua-language-server
    typescript-language-server
    tailwindcss-language-server
    python313Packages.python-lsp-server
    bash-language-server
    nil

    stdenv.cc
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
