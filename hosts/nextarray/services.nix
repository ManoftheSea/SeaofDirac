{
  services = {
    grocy = {
      enable = true;
      hostName = "grocy.seaofdirac.org";
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
    qemuGuest.enable = true;
  };
}
