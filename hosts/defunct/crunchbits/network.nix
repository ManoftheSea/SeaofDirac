{
  networking = {
    domain = "seaofdirac.org";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
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
        "216.126.233.180/22"
        "2606:a8c0:3:35c::a/64"
      ];
      gateway = ["216.126.232.1"];
      networkConfig.LinkLocalAddressing = "ipv6";
      routes = [
        {
          Gateway = "2606:a8c0:3::1";
          GatewayOnLink = true;
        }
      ];
    };
  };
}
