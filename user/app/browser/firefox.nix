{...}: {
  programs.firefox = {
    enable = true;
    profiles."apexu" = {
      extensions.force = true;
    };
  };
}
