{
  config,
  lib,
  ...
}: {
  networking.firewall = {
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
    extraConfig = ''
      include "${config.sops.secrets."bind/rndc_keys".path}";
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
    '';
    extraOptions = ''
      allow-transfer { none; };
    '';

    listenOn = ["!127.0.0.0/8" "any"];
    listenOnIpv6 = ["!::1" "any"];

    zones = {
      "${config.networking.domain}" = {
        file = "/var/dns/seaofdirac.org.db";
        master = false;
        masters = [
          "38.45.65.88"
          #"2001:550:5a00:b28c::1"
        ];
      };
    };
  };

  # Let bind access its secrets
  sops.secrets =
    lib.genAttrs [
      "bind/rndc_keys"
      "bind/config/acls"
      "bind/config/controls"
    ] (_: {
      owner = config.users.users.named.name;
    });

  systemd.tmpfiles.settings."10-bind-zonefiles"."/var/dns".d = {
    inherit (config.users.users.named) group;
    user = config.users.users.named.name;
    mode = "0750";
  };
}
