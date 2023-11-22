{
  config,
  pkgs,
  ...
}: {
  security.acme.certs."technetium.seaofdirac.org".extraDomainNames = [
    "${config.services.nextcloud.hostName}"
  ];

  services.nextcloud = {
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
    enableBrokenCiphersForSSE = false;
    #extraOptions = {
    #  mail_smtpmode = "sendmail";
    #  mail_sendmailmode = "pipe";
    #};
    https = true;
    hostName = "nextcloud.seaofdirac.org";
    package = pkgs.nextcloud27;
    # phpOptions = { upload_max_filesize = "1G"; post_max_size = "1G"; };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    acmeRoot = null;
    enableACME = true;
    forceSSL = true;
  };

  services.postgresql = {
    ensureDatabases = ["nextcloud"];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
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
