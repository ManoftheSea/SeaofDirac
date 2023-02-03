{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        53 # named
      ];
      allowedUDPPorts = [
        53 # named
        67 # dhcp4
        547 # dhcp6
      ];
      trustedInterfaces = [];
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
          IPv6AcceptRA = true;
        };
        ipv6AcceptRAConfig.Token = "::1";
      };
    };
  };
}
