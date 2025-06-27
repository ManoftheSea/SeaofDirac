{
  networking = {
    domain = "internal.seaofdirac.org";
    firewall = {
      allowedTCPPorts = [
        22 # SSH
        5355 # LLMNR
      ];
      allowedUDPPorts = [
        5353 # mDNS
        5355 # LLMNR
      ];
    };
    hostName = "tin";
    nftables.enable = true;
  };
}
