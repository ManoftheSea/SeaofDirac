{
  security.acme.certs."nextarray.seaofdirac.org".group = "certs";

  services = {
    grocy = {
      enable = true;
      hostName = "grocy.seaofdirac.org";
    };
    nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts."nextarray.seaofdirac.org".enableACME = true;
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

  users.groups.certs.members = ["nginx"];
}
