{config, ...}: {
  security.acme.defaults = {
    credentialsFile = config.sops.secrets.rfc2136_secret.path;
    dnsProvider = "rfc2136";
  };
  security.acme.certs."littlecreek.seaofdirac.org".extraDomainNames = [
    "mta-sts.seaofdirac.org"
  ];

  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts = {
        "littlecreek.seaofdirac.org" = {
          enableACME = true;
          acmeRoot = null;
        };
      };
    };

    openssh.hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    qemuGuest.enable = true;
  };

  sops.secrets.rfc2136_secret.owner = config.users.users.acme.name;

  users.groups.certs.members = ["nginx"];
}
