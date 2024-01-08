{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
      ];
      allowedUDPPorts = [5353];
      trustedInterfaces = [];
    };
    hostName = "technetium";
    nftables.enable = true;
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      enp4s0f0 = {
        matchConfig.Name = "enp4s0f0";
        address = ["192.168.200.10/24"];
        gateway = ["192.168.200.1"];
        ipv6AcceptRAConfig.Token = "::10";
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };
      };
    };
  };
}
