{
  pkgs,
  settings,
  ...
}: {
  home.packages = with pkgs; [
    lua-language-server
    clang-tools
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
    lazygit
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    # initLua = builtins.readFile ./init.lua;
  };

  home.file.".config/nvim/colorscheme.txt".text = settings.theme;

  home.file.".config/nvim".source = ./lazy;
  home.file.".config/nvim".recursive = true;
}
