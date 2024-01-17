{
  networking.hostName = "nickel";
  networking.nftables.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      22 # SSH
      5355 # LLMNR
    ];
    allowedUDPPorts = [
      5353 # mDNS
      5355 # LLMNR
    ];
  };
}
