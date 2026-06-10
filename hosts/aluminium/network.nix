{
  networking = {
    firewall = {
      allowedTCPPorts = [
        5355 # LLMNR
      ];
      allowedUDPPorts = [
        5353 # mDNS
        5355 # LLMNR
      ];
    };
    hostName = "aluminium";
    nftables.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
    };
  };
}
