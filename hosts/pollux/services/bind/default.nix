{
  self,
  config,
  lib,
  ...
}: let
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
      include "${config.sops.secrets."bind/config/masters".path}";
      include "${config.sops.secrets."bind/rndc_keys/aluminium".path}";
    '';

    zones =
      lib.mapAttrs (_zoneName: fileLocation: {
        file = fileLocation;
        master = false;
        masters = ["internal-masters"];
      }) {
        "${config.networking.domain}" = "${zonefilesDir}/${config.networking.domain}.db";
        "users.${config.networking.domain}" = "${zonefilesDir}/users.${config.networking.domain}.db";
        "0.1.c.d.c.5.0.1.0.6.2.ip6.arpa" = "${zonefilesDir}/2601.5cd.c10-pd-reverse.db";
        "168.192.in-addr.arpa" = "${zonefilesDir}/192.168.db";
        "20.172.in-addr.arpa" = "${zonefilesDir}/172.20.db";
        "10.in-addr.arpa" = "${zonefilesDir}/10.db";
        "rpz.blocklist" = "${zonefilesDir}/rpz.blocklist";
      };
  };

  sops.secrets =
    lib.mkIf config.services.bind.enable
    (lib.genAttrs [
        "bind/config/acls"
        "bind/config/controls"
        "bind/config/masters"
        "bind/rndc_keys/aluminium"
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
