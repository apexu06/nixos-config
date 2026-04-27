{
  pkgs,
  config,
  lib,
  ...
}: let
  emacsDir = "${config.home.homeDirectory}/.dotfiles/user/app/emacs";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = with pkgs; [
    fd
    ripgrep
    git
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.nixfmt
    ];
  };

  home.activation.installDoom = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:${pkgs.emacs-pgtk}/bin:$PATH"
      ${pkgs.git}/bin/git clone --depth 1 \
        https://github.com/doomemacs/doomemacs \
        $HOME/.config/emacs
      $HOME/.config/emacs/bin/doom install --no-config --no-env
    fi
  '';

  home.file = {
    ".config/doom" = {
      source = link "${emacsDir}/doom";
      recursive = true;
    };
  };

  home.sessionPath = ["$HOME/.config/emacs/bin"];

  # home.file = {
  #   ".config/emacs/init.el".source = link "${emacsDir}/scratch/init.el";
  #   ".config/emacs/early-init.el".source = link "${emacsDir}/scratch/early-init.el";
  #   ".config/emacs/lisp" = {
  #     source = link "${emacsDir}/scratch/lisp";
  #     recursive = true;
  #   };
  # };
}
