{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.seaofdirac.org";
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      adminpassFile = config.sops.secrets.nextcloud_password.path;
      adminuser = "root";
    };
  };

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "nextcloud.seaofdirac.org".useACMEHost = "pollux.seaofdirac.org";
      "pollux.seaofdirac.org".enableACME = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["nextcloud"];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  sops.secrets.nextcloud_password = {
    owner = config.users.users.nextcloud.name;
    group = config.users.groups.nextcloud.name;
  };

  # ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  systemd.services.nextcloud.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
