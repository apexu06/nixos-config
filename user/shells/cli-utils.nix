{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    fd
    devenv
    ripgrep
    findutils
    unzip
    pciutils
    killall
    fastfetch
    gdu
    fzf
    gh
    glab
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
    felix-fm
    chafa
    inputs.systemd-manager-tui.packages.x86_64-linux.default
  ];

  home.shellAliases = {
    cd = "z";
    cat = "bat";
    shit = "shutdown";
    ls = "eza --color=always --all --group-directories-first --long --icons --no-permissions --git";
    lg = "lazygit";
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
    stm = "systemd-manager-tui";
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.television.enable = true;
  programs.lazygit.enable = true;
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      compress = pkgs.yaziPlugins.compress;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "a" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = ["c" "a" "p"];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on = ["c" "a" "h"];
          run = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on = ["c" "a" "l"];
          run = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on = ["c" "a" "u"];
          run = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
      ];
    };
  };
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
