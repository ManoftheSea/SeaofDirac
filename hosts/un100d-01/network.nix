{
  networking = {
    domain = "internal.seaofdirac.org";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
      ];
      allowedUDPPorts = [
        5353 # mDNS
      ];
      trustedInterfaces = [];
    };
    hostName = "un100d-01";
    nftables.enable = true;
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      enp1s0 = {
        matchConfig.Name = "enp1s0";
        address = [
          "192.168.200.6/24"
          "fd8d:5837:3e25:beef::6/64"
        ];
        gateway = ["192.168.200.1"];
        ipv6AcceptRAConfig.Token = "::6";
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };
      };
      # enp3s0 = {};
    };
  };
}
