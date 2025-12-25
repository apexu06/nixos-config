{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    ripgrep
    findutils
    unzip
    killall
    btop
    fastfetch
    gdu
    fzf
    gh
    xdg-utils
    wl-clipboard
    gdb
    rustup
    eza
    devenv
    brightnessctl
    tree
    file
    jq
  ];

  home.shellAliases = {
    cd = "z";
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
    hms = "nh home switch";
    nos = "nh os switch";
  };

  programs.bat.enable = true;
  # programs.television.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.bun.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/apexu/.dotfiles"; # sets NH_OS_FLAKE variable for you
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "apexu";
        email = "jj.zelger@proton.me";
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };

      init.defaultBranch = "main";
    };
  };
}
