_: {
  imports = [];

  networking.firewall.allowedTCPPorts = [8080];

  services = {
    fstrim.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = false;
    };
  };
}
