{
  networking = {
    hostName = "castor";
    useNetworkd = true;
    wireless.enable = false;
    useDHCP = false;
    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = ["br0"];
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [];
    };
  };

  systemd.network = {
    enable = true;
    netdevs.br0.netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      eth0 = {
        matchConfig.Name = "eth0";
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = false;
      };
      wan = {
        matchConfig.Name = "wan";
        address = ["192.168.20.3/24" "2601:5cd:c101:5382::3/64" "fd50:63ed:f2b7:20::3/64"];
        gateway = ["192.168.20.1"];
        networkConfig = {
          MulticastDNS = true;
        };
        ipv6AcceptRAConfig = {
          UseAutonomousPrefix = false;
        };
        dhcpV6Config.UseDelegatedPrefix = false;
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig = {
          Bridge = "br0";
        };
        linkConfig.RequiredForOnline = false;
      };
    };
  };
}
