{
  config,
  pkgs,
  ...
}: let
  hxDir = "${config.home.homeDirectory}/.dotfiles/user/app/helix";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = with pkgs; [
    steelix
  ];

  home.file = {
    ".config/helix" = {
      source = link "${hxDir}/config";
      recursive = true;
    };
  };

  # home.sessionVariables.EDITOR = "hx";
}
