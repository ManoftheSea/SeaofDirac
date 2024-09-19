{config, ...}: {
  security.acme.certs."${config.networking.fqdn}" = {
    dnsProvider = "rfc2136";
    extraDomainNames = [
      "mta-sts.${config.networking.domain}"
    ];
    inherit (config.services.nginx) group;
    webroot = null;
  };

  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts = {
        "${config.networking.fqdn}" = {
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
