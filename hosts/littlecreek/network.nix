{
  networking = {
    domain = "seaofdirac.org";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        443 # https
      ];
      allowedUDPPorts = [
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
        address = [
          "38.45.65.88/24"
          "2001:550:5a00:b28c::1/64"
        ];
        gateway = ["38.45.65.1"];
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };
      };
    };
  };
}
