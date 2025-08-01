_: {
  imports = [
    ./factorio-headless.nix
    ./web-services
  ];

  services = {
    fstrim.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = false;
    };
  };
}
