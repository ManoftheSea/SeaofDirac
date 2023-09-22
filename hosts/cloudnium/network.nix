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
    hostName = "cloudnium";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks.ens3 = {
      matchConfig.Name = "ens3";
      networkConfig.DHCP = "yes";
      address = ["23.26.137.45/24"];
      gateway = ["23.26.137.1"];
    };
  };
}
