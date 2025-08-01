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
    hostName = "interserver-s01";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks.ens3 = {
      DHCP = "yes";
      matchConfig.Name = "ens3";
      networkConfig.LinkLocalAddressing = "ipv6";
    };
  };
}
