{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    ripgrep
    mlocate
    bat
    unzip
    killall
    btop
    fastfetch
    television
    fzf
    gh
    xdg-utils
    yazi
    wl-clipboard
    rustup
    eza
  ];

  home.shellAliases = {
    shit = "shutdown";
    ls = "eza --color=always --all --group-directories-first --long --icons --no-permissions --git";
    xo = "xdg-open";
    n = "nvim";
  };
}
