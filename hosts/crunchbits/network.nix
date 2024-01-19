{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        80 # http
        389 # ldap
        443 # https
      ];
      allowedUDPPorts = [];
      trustedInterfaces = [];
    };
    hostName = "crunchbits";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks.enp3s0 = {
      matchConfig.Name = "enp3s0";
      address = [
        "38.175.192.169/24"
        "2606:a8c0:3::348/128"
        # "2606:a8c0:3:35c::a/64"
      ];
      gateway = ["38.175.192.1"];
      networkConfig.LinkLocalAddressing = "ipv6";
      routes = [
        {
          routeConfig = {
            Gateway = "2606:a8c0:3::1";
            GatewayOnLink = true;
          };
        }
      ];
    };
  };
}
