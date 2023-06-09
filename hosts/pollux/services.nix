{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.netbox = {
    enable = true;
    secretKeyFile = config.sops.secrets.netbox_password.path;
  };

  services.nextcloud = {
    enable = true;
    enableBrokenCiphersForSSE = false;
    https = true;
    hostName = "nextcloud.seaofdirac.org";
    package = pkgs.nextcloud26;
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
    clientMaxBodySize = "25m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "netbox.seaofdirac.org" = {
        locations = {
          "/" = {
            proxyPass = "http://[::1]:8001";
          };
          "/static/" = {
            alias = "${config.services.netbox.dataDir}/static";
          };
        };
        forceSSL = true;
        useACMEHost = "pollux.seaofdirac.org";
      };
      "nextcloud.seaofdirac.org" = {
        forceSSL = true;
        useACMEHost = "pollux.seaofdirac.org";
      };
      "pollux.seaofdirac.org" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
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

  sops.secrets = {
    netbox_password = {
      owner = config.users.users.netbox.name;
      group = config.users.groups.netbox.name;
    };
    nextcloud_password = {
      owner = config.users.users.nextcloud.name;
      group = config.users.groups.nextcloud.name;
    };
  };

  # ensure that postgres is running *before* running the setup
  systemd.services = {
    "nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
    "nextcloud" = {
      requires = ["var-lib-nextcloud.mount"];
      after = ["var-lib-nextcloud.mount"];
    };
  };

  systemd.services.netbox.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
  systemd.services.nextcloud.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
