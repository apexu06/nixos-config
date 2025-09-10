{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    ripgrep
    findutils
    unzip
    killall
    btop
    fastfetch
    fzf
    gh
    xdg-utils
    wl-clipboard
    rustup
    eza
    brightnessctl
    tree
    file
  ];

  home.shellAliases = {
    cat = "bat";
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
    hs = "home-manager switch --flake $HOME/.dotfiles";
    ns = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
  };

  programs.bat.enable = true;
  programs.television.enable = true;
  programs.yazi.enable = true;
}
