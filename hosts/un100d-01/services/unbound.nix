_: {
  networking.firewall.allowedUDPPorts = [53];
  networking.firewall.allowedTCPPorts = [53];

  services.resolved.enable = false;
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = ["enp1s0"];
        port = 53;
        access-control = [
          "192.168.0.0/16 allow"
          "172.16.0.0/20 allow"
          "10.0.0.0/8 allow"
          "2601:5cc:4a01:6fa0::/60 allow"
          "fe80::/64 allow"
        ];
        prefetch = true;
      };
      forward-zone = [
        {
          name = "10.in-addr.arpa.";
          forward-addr = [
            "192.168.200.3"
            "192.168.200.4"
          ];
        }
        {
          name = "172.in-addr.arpa.";
          forward-addr = [
            "192.168.200.3"
            "192.168.200.4"
          ];
        }
        {
          name = "168.192.in-addr.arpa.";
          forward-addr = [
            "192.168.200.3"
            "192.168.200.4"
          ];
        }
        {
          name = "seaofdirac.org.";
          forward-addr = [
            "192.168.200.3"
            "192.168.200.4"
          ];
        }
      ];
    };
  };
}
