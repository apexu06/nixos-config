{config, pkgs, ...}:
{
  programs.git = {
    enable = true;
    userName = "apexu";
    userEmail = "jj.zelger@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
