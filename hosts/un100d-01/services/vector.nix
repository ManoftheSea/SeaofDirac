_: {
  networking.firewall.allowedUDPPorts = [514];

  services.vector = {
    enable = true;
    settings = {
      sources.syslog-udp-listener = {
        type = "syslog";
        address = "[::]:514";
        mode = "udp";
      };
      sinks.loki = {
        type = "loki";
        inputs = ["syslog-udp-listener"];
        endpoint = "https://interserver-s01.seaofdirac.org";
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
