{config, ...}: {
  imports = [
    ./bind
    ./kea
    ./postgresql.nix
  ];

  security.acme.certs."${config.networking.fqdn}" = {};
}
