{
  config,
  lib,
  ...
}: let
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
      enforced = "body";
    };
    indexDir = "/var/lib/dovecot/indices";
    localDnsResolver = false;
    loginAccounts = {
      "derek@seaofdirac.org" = {
        hashedPasswordFile = config.sops.secrets."dovecot_users/derek".path;
        aliases = [
          "root@seaofdirac.org"
          "postmaster@seaofdirac.org"
          "security@seaofdirac.org"
        ];
      };
      "benjamin@seaofdirac.org".hashedPasswordFile = config.sops.secrets."dovecot_users/benjamin".path;
      "ruckus@seaofdirac.org".hashedPasswordFile = config.sops.secrets."dovecot_users/ruckus".path;
    };
  };

  services.dovecot2.sieve.extensions = ["fileinto"]; # fix for dovecot change in 24.05

  sops.secrets = let
    dovecot_keys = [
      "dovecot_users/benjamin"
      "dovecot_users/derek"
      "dovecot_users/ruckus"
    ];
  in
    lib.genAttrs dovecot_keys (_: {
      owner = config.users.users.dovecot2.name;
    });

  systemd.services.dovecot2.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
