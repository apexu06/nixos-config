{...}: {
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;

    containers = {
      arch = {
        additional_packages = "git neovim python";
        image = "quay.io/toolbx/arch-toolbox:latest";
        init = true;
      };
    };
  };
}
