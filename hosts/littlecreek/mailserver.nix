{config, ...}: let
  myDomain = config.networking.domain;
in {
  mailserver = {
    inherit (config.networking) fqdn;
    enable = true;

    certificateScheme = "acme";
    domains = ["${myDomain}"];
    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      # this only applies to plain text attachments, binary attachments are never indexed
      indexAttachments = true;
      enforced = "body";
    };
    indexDir = "/var/lib/dovecot/indices";
    localDnsResolver = false;
    loginAccounts = {
      "derek@seaofdirac.org" = {
        hashedPasswordFile = config.sops.secrets.derek_password.path;
        aliases = [
          "root@seaofdirac.org"
          "postmaster@seaofdirac.org"
          "security@seaofdirac.org"
        ];
      };
      "benjamin@seaofdirac.org".hashedPasswordFile = config.sops.secrets.benjamin_password.path;
      "jessica@seaofdirac.org".hashedPasswordFile = config.sops.secrets.derek_password.path;
      "nextcloud@seaofdirac.org".hashedPasswordFile = config.sops.secrets.nextcloud_password.path;
    };
  };

  services = {
    dovecot2.sieve.extensions = ["fileinto"]; # fix for dovecot change in 24.05

    nginx = {
      enable = true;
      virtualHosts."mta-sts.${myDomain}" = {
        useACMEHost = "${config.networking.fqdn}";
        forceSSL = true;
        root = "/var/www/mta-sts.${config.networking.domain}";
      };
    };
  };

  sops.secrets = {
    benjamin_password.owner = config.users.users.dovecot2.name;
    derek_password.owner = config.users.users.dovecot2.name;
    nextcloud_password.owner = config.users.users.dovecot2.name;
  };

  systemd.services.dovecot2.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
