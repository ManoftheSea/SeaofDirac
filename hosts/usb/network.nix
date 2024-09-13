_: {
  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;

    netdevs.bridge0.netdevConfig = {
      Name = "bridge0";
      Kind = "bridge";
    };
    networks = {
      interfaces = {
        matchConfig.Name = "enp*s0";
        networkConfig = {
          Bridge = "bridge0";
          LinkLocalAddressing = "no";
        };
        linkConfig.RequiredForOnline = false;
      };
      bridge = {
        matchConfig.Name = "bridge0";
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = false;
      };
    };
  };
}
