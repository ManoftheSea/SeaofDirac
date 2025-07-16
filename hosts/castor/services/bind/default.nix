{
  self,
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  zonefilesDir = "/var/dns";
in {
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
      response-policy { zone "blocklist.rpz"; zone "seaofdirac.org.rpz";};

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

    listenOn = ["!127.0.0.0/8" "192.168.0.0/16"];
    listenOnIpv6 = ["!::1" "any"];

    zones =
      lib.mapAttrs (_zoneName: zoneAttrs: {
        inherit (zoneAttrs) file;
        master = true;
        slaves = ["trusted"]; # Acts as allow-transfer, doesn't notify
      }) {
        "${config.networking.domain}" = {
          file = "${zonefilesDir}/${config.networking.domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "ddns.${config.networking.domain}" = {
          file = "${zonefilesDir}/ddns.${config.networking.domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "c.5.0.1.0.6.2.ip6.arpa" = {
          file = "${zonefilesDir}/2601.5c-pd-reverse.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "168.192.in-addr.arpa" = {
          file = "${zonefilesDir}/192.168.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "101.168.192.in-addr.arpa" = {
          file = "${zonefilesDir}/192.168.101.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "102.168.192.in-addr.arpa" = {
          file = "${zonefilesDir}/192.168.102.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "20.172.in-addr.arpa" = {
          file = "${zonefilesDir}/172.20.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "10.in-addr.arpa" = {
          file = "${zonefilesDir}/10.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "blocklist.rpz".file = "${zonefilesDir}/blocklist.rpz";
        "seaofdirac.org.rpz".file = "${zonefilesDir}/seaofdirac.org.rpz";
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
    bind-zones."${zonefilesDir}".d = {
      group = "named";
      mode = "750";
      user = "named";
    };
  };
}
