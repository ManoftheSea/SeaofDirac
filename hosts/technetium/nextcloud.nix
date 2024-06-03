{
  config,
  pkgs,
  ...
}: let
  myFQDN = "technetium.seaofdirac.org";
in {
  security.acme.certs.${myFQDN}.extraDomainNames = [
    "${config.services.nextcloud.hostName}"
  ];

  services = {
    nextcloud = {
      enable = true;
      config = {
        adminpassFile = config.sops.secrets.nextcloud_password.path;
        adminuser = "root";
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
        dbname = "nextcloud";
      };
      configureRedis = true;
      #extraOptions = {
      #  mail_smtpmode = "sendmail";
      #  mail_sendmailmode = "pipe";
      #};
      https = true;
      hostName = "nextcloud.seaofdirac.org";
      package = pkgs.nextcloud29;
      # phpOptions = { upload_max_filesize = "1G"; post_max_size = "1G"; };
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = myFQDN;
    };

    postgresql = {
      ensureDatabases = ["nextcloud"];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };
  };

  sops.secrets.nextcloud_password.owner = config.users.users.nextcloud.name;

  # ensure that postgres is running *before* running the setup
  systemd.services = {
    "nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
    "phpfpm-nextcloud" = {
      requires = ["var-lib-nextcloud.mount"];
      after = ["var-lib-nextcloud.mount"];
    };
  };
}
