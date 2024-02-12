{config, ...}: {
  mailserver = {
    enable = true;

    certificateScheme = "acme";
    domains = ["seaofdirac.org"];
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
    fqdn = "littlecreek.seaofdirac.org";
  };

  services.nginx = {
    enable = true;
    virtualHosts."mta-sts.seaofdirac.org" = {
      useACMEHost = "littlecreek.seaofdirac.org";
      forceSSL = true;
      root = "/var/www/mta-sts.seaofdirac.org";
    };
  };

  sops.secrets.benjamin_password.owner = config.users.users.dovecot2.name;
  sops.secrets.derek_password.owner = config.users.users.dovecot2.name;
  sops.secrets.nextcloud_password.owner = config.users.users.dovecot2.name;
  systemd.services.dovecot2.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
