{
  networking = {
    hostName = "pollux";
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
      };
      wan = {
        matchConfig.Name = "wan";
        address = ["192.168.20.4/24" "2601:5cd:c101:5382::4/64" "fd50:63ed:f2b7:20::4/64"];
        gateway = ["192.168.20.1" "fe80::1"];
        networkConfig = {
          MulticastDNS = true;
        };
        dhcpV6Config.UseDelegatedPrefix = false;
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig = {
          Bridge = "br0";
        };
      };
    };
  };
}
