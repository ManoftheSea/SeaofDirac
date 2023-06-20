{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.netbox = {
    enable = true;
    extraConfig = "CSRF_TRUSTED_ORIGINS = [\"https://netbox.seaofdirac.org\"]";
    secretKeyFile = config.sops.secrets.netbox_password.path;
  };

  services.nginx.virtualHosts."netbox.seaofdirac.org" = {
    locations = {
      "/".proxyPass = "http://[::1]:8001";
      "/static/".alias = "${config.services.netbox.dataDir}/static/";
    };
    forceSSL = true;
    useACMEHost = "littlecreek.seaofdirac.org";
  };

  sops.secrets.netbox_password = {
    owner = config.users.users.netbox.name;
    group = config.users.groups.netbox.name;
  };

  systemd.services.netbox.serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
  systemd.services.nginx.serviceConfig.SupplementaryGroups = [config.users.groups.netbox.name];
}
