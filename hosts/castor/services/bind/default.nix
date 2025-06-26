{
  self,
  config,
  lib,
  ...
}: {
  networking.firewall = lib.mkIf config.services.bind.enable {
    allowedTCPPorts = [
      53 # named
      953 # rndc
    ];
    allowedUDPPorts = [
      53 # named
    ];
  };

  services.bind = {
    enable = true;
    cacheNetworks = [
      "internal"
    ];
    extraOptions = ''
      response-policy { zone "rpz.blocklist"; };

      dns64 64:ff9b::/96 {
        clients { !translator; dns64-good-clients; };
        mapped { !rfc1918; !rfc6598; any; };
        exclude { !ula-prefixes; 0::/3; 4000::/2; 8000::/1; 2001:db8::/32; };
        break-dnssec yes;
        recursive-only yes;
      };
    '';
    extraConfig = ''
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
      include "${config.sops.secrets."bind/ddns-keys".path}";
      include "${config.sops.secrets."bind/rndc_keys".path}";
    '';

    zones =
      lib.mapAttrs (_zoneName: zoneAttrs: {
        inherit (zoneAttrs) file;
        extraConfig =
          ''
            notify explicit;
            also-notify { 192.168.200.4; };
          ''
          + zoneAttrs.extraConfig;
        master = true;
        slaves = ["trusted"];
      }) {
        "${config.networking.domain}" = {
          file = "/var/dns/${config.networking.domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "users.${config.networking.domain}" = {
          file = "/var/dns/users.${config.networking.domain}.db";
          extraConfig = ''
            update-policy {
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "c.5.0.1.0.6.2.ip6.arpa" = {
          file = "/var/dns/2601.5c-pd-reverse.db";
          extraConfig = ''
            update-policy {
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "168.192.in-addr.arpa" = {
          file = "/var/dns/192.168.db";
          extraConfig = ''
            update-policy {
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "20.172.in-addr.arpa" = {
          file = "/var/dns/172.20.db";
          extraConfig = ''
            update-policy {
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "10.in-addr.arpa" = {
          file = "/var/dns/10.db";
          extraConfig = ''
            update-policy {
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "rpz.blocklist" = {
          file = "/var/dns/rpz.blocklist";
          extraConfig = ''
            update-policy {};
          '';
        };
      };
  };

  sops.secrets =
    lib.mkIf config.services.bind.enable
    (lib.genAttrs [
        "bind/config/acls"
        "bind/config/controls"
        "bind/ddns-keys"
        "bind/rndc_keys"
      ] (_: {
        owner = config.users.users.named.name;
        sopsFile = "${self}/hosts/secrets/bind.yaml";
      }));

  # These are required in 24.11, but part of the definition in unstable (20250405)
  systemd.services.bind.serviceConfig = lib.mkIf config.services.bind.enable {
    AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
    ConfigurationDirectory = "bind";
    RuntimeDirectory = "named";
    RuntimeDirectoryPreserve = "yes";
    User = "named";
  };

  systemd.tmpfiles.settings = lib.mkIf config.services.bind.enable {
    bind-zones."/var/dns".d = {
      group = "named";
      mode = "750";
      user = "named";
    };
  };
}
