{
  pkgs,
  lib,
  config,
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
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.nixfmt
    ];
  };

  home.activation.installDoom = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      ${pkgs.git}/bin/git clone --depth 1 \
        https://github.com/doomemacs/doomemacs \
        $HOME/.config/emacs
      $HOME/.config/emacs/bin/doom install --no-config --no-env
    fi
  '';

  home.file = {
    ".config/doom/init.el".source = link "${emacsDir}/init.el";
    ".config/doom/config.el".source = link "${emacsDir}/config.el";
    ".config/doom/packages.el".source = link "${emacsDir}/packages.el";
  };

  home.sessionPath = ["$HOME/.config/emacs/bin"];
}
