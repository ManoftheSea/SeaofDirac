{
  security.acme.certs."cloudnium.seaofdirac.org" = {
    webroot = "/var/lib/acme/.challenges";
    group = "certs";
  };

  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts."cloudnium.seaofdirac.org".enableACME = true;
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
