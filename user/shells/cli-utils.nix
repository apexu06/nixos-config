{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    ripgrep
    findutils
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
    brightnessctl
  ];

  home.shellAliases = {
    shit = "shutdown";
    ls = "eza --color=always --all --group-directories-first --long --icons --no-permissions --git";
    xo = "xdg-open";
    n = "nvim";
    e = "exit";
    ga = "git add";
    gc = "git commit";
    gs = "git status";
    gp = "git push";
    gpl = "git pull";
  };
}
