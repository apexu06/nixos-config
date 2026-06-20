{...}: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
    };
  };

  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jzep";
        email = "jj.zelger@proton.me";
      };
      # url = {
      #   "ssh://git@github.com/" = {
      #     insteadOf = "https://github.com/";
      #   };
      # };

      init.defaultBranch = "main";

      merge = {
        conflictStyle = "zdiff3";
      };
    };
  };
}
