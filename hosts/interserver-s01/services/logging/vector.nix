_: {
  services.vector = {
    enable = true;
    settings = {
      sources.host_journald = {
        type = "journald";
        current_boot_only = true;
        since_now = true;
        include_units = [
          "acme-interserver-s01.seaofdirac.org"
          "garage"
          "grafana"
          "loki"
          "nginx"
        ];
      };
      sinks.loki = {
        type = "loki";
        inputs = ["host_journald"];
        endpoint = "http://localhost:3100";
        encoding.codec = "json";
        labels = {
          host = "{{ host }}";
          source = "journald";
          transport = "vector";
        };
      };
    };
  };

  systemd.services.vector.serviceConfig.SupplementaryGroups = ["systemd-journal"];
}
