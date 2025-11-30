{
  programs.thunderbird = {
    enable = true;
    profiles = {};
  };

  accounts.email.accounts = {
    "coolcrafter06@gmail.com" = {
      address = "coolcrafter06@gmail.com";
      primary = true;
      thunderbird.enable = true;
    };
  };

  programs.vesktop = {
    enable = true;
  };

  programs.zathura.enable = true;
}
