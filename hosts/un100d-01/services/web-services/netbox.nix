{
  config,
  lib,
  pkgs,
  ...
}: let
  # inherit (config.networking) domain fqdn;
  domain = "seaofdirac.org";
  fqdn = "${config.networking.hostName}.${domain}";
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["netbox.${domain}"];

  services = {
    netbox = {
      enable = true;
      extraConfig = ''
        with open("/run/secrets/netbox/password", "r") as file:
          DATABASE["PASSWORD"] = file.readline()
      '';
      package = pkgs.netbox_4_4;
      plugins = p: [
        p.netbox-topology-views
      ];
      secretKeyFile = "/run/secrets/netbox/secret";
      settings = {
        DATABASE.HOST = lib.mkForce "castor.internal.seaofdirac.org";
        ENFORCE_GLOBAL_UNIQUE = false;
        PLUGINS = [
          "netbox_topology_views"
        ];
      };
    };

    nginx.virtualHosts."netbox.${domain}" = {
      locations = {
        "/".proxyPass = "http://${config.services.netbox.listenAddress}:${builtins.toString config.services.netbox.port}";
        "/static/".alias = "${config.services.netbox.dataDir}/static/";
      };
      forceSSL = true;
      useACMEHost = fqdn;
    };

    postgresql.enable = lib.mkForce false;
  };

  sops.secrets =
    lib.genAttrs [
      "netbox/secret"
      "netbox/password"
    ] (_: {
      owner = config.users.users.netbox.name;
      group = config.users.groups.netbox.name;
    });

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [config.users.groups.netbox.name];
}
