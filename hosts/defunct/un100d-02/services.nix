_: {
  imports = [];

  services = {
    fstrim.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = false;
    };
  };
}
