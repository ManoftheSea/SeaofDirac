{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [
    67 #dhcp
    547 #dhcpv6
  ];

  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        hosts-database = {
          type = "postgresql";
          name = "kea";
          host = "/run/postgresql";
          user = "kea";
        };
        lease-database = {
          type = "postgresql";
          name = "kea";
          host = "/run/postgresql";
          user = "kea";
        };
        interfaces-config = {
          dhcp-socket-type = "udp";
          interfaces = ["enp4s0f0/192.168.200.10"];
        };
        option-data = [
          {
            name = "domain-name-servers";
            data = "192.168.200.5";
          }
        ];
        authoritative = true;
        subnet4 = [
          {
            id = 101;
            option-data = [
              {
                name = "routers";
                data = "192.168.101.1";
              }
              {
                name = "time-servers";
                data = "192.168.101.1";
              }
              {
                name = "domain-name";
                data = "users.seaofdirac.org";
              }
              {
                name = "domain-search";
                data = "seaofdirac.org";
              }
              #{
              #  name = "v6-only-preferred";
              #  data = "1800";
              #}
            ];
            pools = [
              {
                pool = "192.168.101.100 - 192.168.101.200";
              }
            ];
            subnet = "192.168.101.0/24";
          }
          {
            id = 201;
            option-data = [
              {
                name = "routers";
                data = "192.168.201.1";
              }
            ];
            reservations = [
              {
                hw-address = "04:0e:3c:58:90:06";
                ip-address = "192.168.201.3";
                hostname = "printer.seaofdirac.org";
              }
            ];
            subnet = "192.168.201.0/24";
          }
          {
            id = 400;
            option-data = [
              {
                name = "domain-name-servers";
                data = "8.8.8.8, 1.1.1.1";
              }
            ];
            pools = [
              {
                pool = "172.20.20.100 - 172.20.20.200";
              }
            ];
            reservations = [
              {
                hw-address = "e4:95:6e:40:ec:23";
                ip-address = "172.20.20.50";
                hostname = "Mango";
              }
              {
                hw-address = "ae:ae:19:3d:c2:2f";
                ip-address = "172.20.20.60";
                hostname = "BasementRoku";
              }
              {
                hw-address = "2c:ea:dc:cd:76:9f";
                ip-address = "172.20.20.70";
                hostname = "t-mobile";
              }
              {
                hw-address = "3c:a9:f4:25:66:3c";
                ip-address = "172.20.20.80";
                hostname = "upquark";
              }
              {
                hw-address = "ae:dc:47:70:91:37";
                ip-address = "172.20.20.90";
                hostname = "oneplus";
              }
            ];
            subnet = "172.20.20.0/24";
          }
        ];
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["kea"];
    ensureUsers = [
      {
        name = "kea";
        ensureDBOwnership = true;
      }
    ];
  };
}
