{
  networking = {
    hostName = "ebin-v7";
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
        networkConfig = {
          DHCP = "yes";
        };
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
