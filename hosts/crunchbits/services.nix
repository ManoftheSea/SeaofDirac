{config, ...}: {
  security.acme.defaults = {
    credentialsFile = config.sops.secrets.rfc2136_secret.path;
    dnsProvider = "rfc2136";
    group = "certs";
  };

  services = {
    nginx = {
      enable = false;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts = {
        "crunchbits.seaofdirac.org" = {
          enableACME = true;
          acmeRoot = null;
        };
      };
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
