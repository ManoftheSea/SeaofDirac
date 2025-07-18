{config, ...}: {
  imports = [
    ./bind
    ./kea
    ./oxidized
    ./postgresql.nix
  ];

  security.acme.certs."${config.networking.fqdn}" = {};
}
