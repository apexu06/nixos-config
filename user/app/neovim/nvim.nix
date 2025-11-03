{
  pkgs,
  inputs,
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
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  xdg.configFile."nvim".source = ./.;
  xdg.configFile."nvim".recursive = true;
}
