{
  services = {
    nix-serve = {
      enable = true;
      port = 8080;
    };

    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
