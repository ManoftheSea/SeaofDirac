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
    enableSubmission = true;

    accounts = {
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
    domains = ["${myDomain}"];
    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
    };
    indexDir = "/var/lib/dovecot/indices";
    localDnsResolver = false;
    stateVersion = 3; # After migration script 20260112
    x509.useACMEHost = config.mailserver.fqdn;
  };

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

  systemd.services.dovecot.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
