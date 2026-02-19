_: {
  networking = {
    domain = "seaofdirac.org";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [5353];
    };
    hostName = "castor";
    hosts = {
      "192.168.200.1" = ["gluon.internal.seaofdirac.org" "gluon.seaofdirac.org"];
      "192.168.200.3" = ["castor.internal.seaofdirac.org" "castor.seaofdirac.org"];
      "192.168.200.4" = ["pollux.internal.seaofdirac.org" "pollux.seaofdirac.org"];
      "fe80::1%wan" = ["gluon.internal.seaofdirac.org"];
      "2601:5cc:4a02:ffc0::3" = ["castor.internal.seaofdirac.org" "castor.seaofdirac.org"];
      "2601:5cc:4a02:ffc0::4" = ["pollux.internal.seaofdirac.org" "pollux.seaofdirac.org"];
    };
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
      #  linkConfig.RequiredForOnline = false;
      #};
      wan = {
        matchConfig.Name = "wan";
        address = ["192.168.200.3/24" "192.168.200.4/24"];
        gateway = ["192.168.200.1"];
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
          MulticastDNS = true;
        };
        dhcpV6Config.UseDelegatedPrefix = false;
        ipv6AcceptRAConfig.Token = ["::3" "::4"];
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = false;
      };
    };
  };
}
