{
  config,
  pkgs,
  ...
}: let
  inherit (config.security.acme) certs;
  inherit (config.networking) fqdn;
in {
  networking.firewall.allowedTCPPorts = [5432];

  services.postgresql = {
    enable = true;
    authentication = ''
      host netbox netbox 192.168.200.0/24 scram-sha-256
      host netbox netbox 2601:5cc:4a01:6fa0::/64 scram-sha-256
    '';
    enableTCPIP = true; # listen on external ports
    package = pkgs.postgresql_16;
    settings = {
      ssl = true;
      ssl_cert_file = "/run/credentials/postgresql.service/fullchain.pem";
      ssl_key_file = "/run/credentials/postgresql.service/key.pem";
    };
  };

  systemd.services.postgresql.serviceConfig.LoadCredential = [
    "fullchain.pem:${certs."${fqdn}".directory}/fullchain.pem"
    "key.pem:${certs."${fqdn}".directory}/key.pem"
  ];
}
