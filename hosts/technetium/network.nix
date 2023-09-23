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
    hostName = "technetium";
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      eno1 = {
        matchConfig.Name = "eno1";
        address = ["192.168.30.10/24"];
        gateway = ["192.168.30.1"];
      };
    };
  };
}
