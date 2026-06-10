{
  self,
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  bindSecrets = [
    "bind/config/acls"
    "bind/config/controls"
    "bind/keys/ddns"
    "bind/keys/rndc"
  ];
  certFQDN = "${config.networking.hostName}.${domain}";
  mkAddrList = myList: builtins.toString (builtins.map (addr: addr + ";") myList);
  zonefilesDir = "/var/dns";
in {
  networking.firewall = lib.mkIf config.services.bind.enable {
    allowedTCPPorts = [
      53 # named
      443 # DNS-over-HTTPS
      853 # DNS-over-TLS
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
    checkConfig = false; # Can't check with secrets under sops
    extraOptions = ''
      response-policy {
        zone "blocklist.rpz";
      };

      dns64 64:ff9b::/96 {
        clients { !translator; dns64-good-clients; };
        mapped { !rfc1918; !rfc6598; any; };
        exclude { !ula-prefixes; 0::/3; 4000::/2; 8000::/1; 2001:db8::/32; };
        break-dnssec yes;
        recursive-only yes;
      };

      listen-on port 443 tls internal-tls-policy http default {${mkAddrList config.services.bind.listenOn}};
      listen-on port 853 tls internal-tls-policy {${mkAddrList config.services.bind.listenOn}};
      listen-on-v6 port 443 tls internal-tls-policy http default {${mkAddrList config.services.bind.listenOnIpv6}};
      listen-on-v6 port 853 tls internal-tls-policy {${mkAddrList config.services.bind.listenOnIpv6}};
      query-source-v6 address 2601:5cc:4a02:b620::3;
    '';
    extraConfig = ''
      tls internal-tls-policy {
        key-file "/run/credentials/bind.service/key.pem";
        cert-file "/run/credentials/bind.service/fullchain.pem";
        protocols { TLSv1.3; };
        session-tickets no;
      };

      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
      include "${config.sops.secrets."bind/keys/ddns".path}";
      include "${config.sops.secrets."bind/keys/rndc".path}";
    '';

    listenOn = ["any"];
    listenOnIpv6 = ["any"];

    zones =
      lib.mapAttrs (_zoneName: zoneAttrs: {
        inherit (zoneAttrs) file;
        master = true;
        slaves = ["trusted"]; # Acts as allow-transfer, doesn't notify
      }) {
        "internal.${domain}" = {
          file = "${zonefilesDir}/internal.${domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "ddns.internal.${domain}" = {
          file = "${zonefilesDir}/ddns.internal.${domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
              grant ddns.castor.seaofdirac.org. zonesub any;
              grant ddns.pollux.seaofdirac.org. zonesub any;
            };
          '';
        };
        "iot.${domain}" = {
          file = "${zonefilesDir}/iot.${domain}.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        # IPv6 reverse zones
        "c.5.0.1.0.6.2.ip6.arpa" = {
          file = "${zonefilesDir}/2601.5c-pd-reverse.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        "d.f.ip6.arpa" = {
          file = "${zonefilesDir}/ula.db";
          extraConfig = ''
            update-policy {
              grant aluminium zonesub any;
            };
          '';
        };
        # IPv4 reverse zones
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
        "21.172.in-addr.arpa" = {
          file = "${zonefilesDir}/172.21.db";
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
        # Utility zones
        "blocklist.rpz".file = "${zonefilesDir}/blocklist.rpz";
        "local.rpz".file = "${zonefilesDir}/local.rpz";
      };
  };

  services.resolved.settings.Resolve = {
    DNS = ["127.0.0.1" "::1"];
    Domains = [
      config.networking.domain
      "internal.${config.networking.domain}"
    ];
  };

  sops.secrets =
    lib.mkIf config.services.bind.enable
    (lib.genAttrs bindSecrets (_: {
      owner = config.users.users.named.name;
      sopsFile = "${self}/hosts/secrets/bind.yaml";
    }));

  security.acme.certs.${certFQDN}.reloadServices = ["bind"];

  systemd.services.bind = lib.mkIf config.services.bind.enable {
    serviceConfig.LoadCredential = [
      "key.pem:${config.security.acme.certs.${certFQDN}.directory}/key.pem"
      "fullchain.pem:${config.security.acme.certs.${certFQDN}.directory}/fullchain.pem"
    ];
    restartTriggers = builtins.map (secret: builtins.getAttr "sopsFileHash" (builtins.getAttr secret config.sops.secrets)) bindSecrets;
    wants = ["acme-${certFQDN}.service"];
  };

  systemd.tmpfiles.settings = lib.mkIf config.services.bind.enable {
    bind-zones."${zonefilesDir}".d = {
      group = "named";
      mode = "750";
      user = "named";
    };
  };
}
