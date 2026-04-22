{pkgs, ...}: {
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
}
