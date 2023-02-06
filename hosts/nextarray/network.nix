{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        80 # http
        443 # https
      ];
      allowedUDPPorts = [];
      trustedInterfaces = [];
    };
    hostName = "nextarray";
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
        };
      };
    };
  };
}
