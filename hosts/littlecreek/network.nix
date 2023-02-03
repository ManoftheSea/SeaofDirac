{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = [];
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [];
    };
    hostName = "littlecreek";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      ens3 = {
        matchConfig.Name = "ens3";
        networkConfig = {
          DHCP = "yes";
          # @TODO IPv6
        };
      };
    };
  };
}
