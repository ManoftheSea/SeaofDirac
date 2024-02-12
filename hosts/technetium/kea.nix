{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./kea/dhcpv4.nix
    ./kea/dhcpv6.nix
    ./kea/dhcp-ddns.nix
  ];

  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [
    67 #dhcp
    547 #dhcpv6
  ];

  services.postgresql = {
    ensureDatabases = ["kea"];
    ensureUsers = [
      {
        name = "kea";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services = {
    "kea-dhcp4-server" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
    "kea-dhcp6-server" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
  };
}
