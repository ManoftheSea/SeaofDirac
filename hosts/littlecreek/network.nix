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
        #address = ["2001:550:5a00:b28c::1/64"];
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };
      };
    };
  };
}
