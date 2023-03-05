{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        53 # named
        443 # https
      ];
      allowedUDPPorts = [
        53 # named
        546 # dhcp6
      ];
    };
    hostName = "littlecreek";
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks = {
      ens3 = {
        matchConfig.Name = "ens3";
        address = ["2001:550:5a00:b28c::1/64"];
        gateway = ["fe80::6ef0:49ff:fee2:9df6"];
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };
      };
    };
  };
}
