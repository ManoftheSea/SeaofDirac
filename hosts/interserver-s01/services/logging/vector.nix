_: {
  networking.firewall.allowedTCPPorts = [514];
  networking.firewall.allowedUDPPorts = [514];

  services.vector = {
    enable = true;
    settings = {
      sources = {
        syslog-udp-listener = {
          type = "syslog";
          address = "[::]:514";
          mode = "udp";
        };
      };
      sinks.loki = {
        type = "loki";
        inputs = ["syslog-udp-listener"];
        endpoint = "http://localhost:3100";
        encoding.codec = "json";
        labels = {
          source = "syslog";
          protocol = "udp";
          transport = "vector";
        };
      };
    };
  };
}
