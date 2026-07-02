_: {
  networking = {
    domain = "seaofdirac.org";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [5353];
    };
    hostName = "pollux";
    nftables.enable = true;
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    netdevs.br0 = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
      bridgeConfig = {
        MulticastIGMPVersion = 3;
        #MulticastMLDVersion = 2;
        STP = true;
        VLANFiltering = true;
      };
    };
    networks = {
      br0 = {
        matchConfig.Name = "br0";
        address = ["192.168.200.4/24"];
        dhcpV6Config.UseDelegatedPrefix = false;
        gateway = ["192.168.200.1"];
        ipv6AcceptRAConfig.Token = ["::4"];
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
          MulticastDNS = true;
        };
      };
      lan = {
        matchConfig.Name = "lan*";
        bridgeConfig = {
          AllowPortToBeRoot = false;
          FastLeave = true;
          UseBPDU = true;
        };
        linkConfig.RequiredForOnline = false;
        networkConfig.Bridge = "br0";
      };
      wan = {
        matchConfig.Name = "wan";
        bridgeConfig = {
          AllowPortToBeRoot = false;
          FastLeave = true;
          UseBPDU = true;
        };
        linkConfig.RequiredForOnline = false;
        networkConfig.Bridge = "br0";
      };
    };
  };
}
