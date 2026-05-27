{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
  ];
  imports = [
    ./home.nix
  ];
}
