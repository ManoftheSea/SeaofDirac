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
    netdevs.br0.netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      #eth0 = {
      #  matchConfig.Name = "eth0";
      #  networkConfig.LinkLocalAddressing = "no";
      #  linkConfig = {
      #    RequiredForOnline = false;
      #  };
      #};
      wan = {
        matchConfig.Name = "wan";
        address = ["192.168.200.4/24"];
        gateway = ["192.168.200.1"];
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
          MulticastDNS = true;
        };
        dhcpV6Config.UseDelegatedPrefix = false;
        ipv6AcceptRAConfig.Token = ["::4"];
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = false;
      };
    };
  };
}
