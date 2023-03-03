{config,...}:{
  mailserver = {
    enable = true;
    fqdn = "littlecreek.seaofdirac.org";
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
  };

  sops.secrets.derek_password.owner = config.users.users.dovecot2.name;
  systemd.services.dovecot2.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
}
