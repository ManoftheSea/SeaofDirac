{config, ...}: {
  mailserver = {
    enable = true;
    certificateScheme = 3;
    domains = ["seaofdirac.org"];
    loginAccounts = {
      "derek@seaofdirac.org" = {
        hashedPasswordFile = config.sops.secrets.derek_password.path;
        aliases = [
          "root@seaofdirac.org"
          "postmaster@seaofdirac.org"
          "security@seaofdirac.org"
        ];
      };
      "jessica@seaofdirac.org".hashedPasswordFile = config.sops.secrets.derek_password.path;
      "benjamin@seaofdirac.org".hashedPasswordFile = config.sops.secrets.derek_password.path;
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

  sops.secrets.derek_password.owner = config.users.users.dovecot2.name;
  systemd.services.dovecot2.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
