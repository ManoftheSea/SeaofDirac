{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./kea/dhcpv4.nix
    ./kea/dhcpv6.nix
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
}
