{
  config,
  lib,
  pkgs,
  self,
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
      extraConfig =
        ''
          with open("/run/secrets/netbox/password", "r") as file:
            DATABASE["PASSWORD"] = file.readline()

        ''
        + ''
          def list_to_ranges(lst):
            ranges = []
            start = lst[0]
            end = lst[0]

            for interface in lst[1:]:
                i = interface.rsplit('/', 1)
                e = end.rsplit('/', 1)

                if i[0] == e[0] and int(i[1]) == int(e[1]) + 1:
                    end = interface
                else:
                    if start == end:
                        ranges.append(str(start))
                    else:
                        ranges.append(f"{start} to {end}")
                    start = interface
                    end = interface

            if start == end:
                ranges.append(str(start))
            else:
                ranges.append(f"{start} to {end}")

            return ranges

          JINJA2_FILTERS = {"list_to_ranges": list_to_ranges}

        '';
      package = self.packages.${pkgs.system}.netbox_4_4;
      plugins = p: [
        p.netbox-dns
        p.netbox-topology-views
        self.packages.${pkgs.system}.python.pkgs.netbox-acls
      ];
      secretKeyFile = "/run/secrets/netbox/secret";
      settings = {
        DATABASE.HOST = lib.mkForce "castor.internal.seaofdirac.org";
        ENFORCE_GLOBAL_UNIQUE = false;
        PLUGINS = [
          "netbox_acls"
          "netbox_dns"
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
