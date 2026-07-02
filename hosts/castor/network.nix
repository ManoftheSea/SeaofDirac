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
      "fe80::1%wan" = ["gluon.internal.seaofdirac.org"];
      "fd8d:5837:3e25:beef::1" = ["gluon.internal.seaofdirac.org"];
      "fd8d:5837:3e25:beef::3" = ["castor.internal.seaofdirac.org"];
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
        address = [
          "192.168.200.3/24"
          "fd8d:5837:3e25:beef::3/64"
        ];
        gateway = ["192.168.200.1"];
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
          MulticastDNS = true;
          NTP = ["fd8d:5837:3e25:beef::1"];
        };
        dhcpV6Config.UseDelegatedPrefix = false;
        ipv6AcceptRAConfig.Token = ["::3"];
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = false;
      };
    };
  };
}
