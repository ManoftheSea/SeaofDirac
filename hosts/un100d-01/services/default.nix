_: {
  imports = [
    ./ddclient.nix
    ./factorio-headless.nix
    ./postgresql.nix
    ./vector.nix
    ./web-services
    ./zwave-js.nix
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
