{config, ...}: {
  services.prometheus = {
    enable = true;

    exporters.node = {
      enable = true;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
    };

    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };
      clients = [{url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";}];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            labels = {
              job = "systemd-journal";
              hostname = "technetium";
            };
            max_age = "12h";
            path = "/var/log/journal";
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
            {
              source_labels = ["__journal_priority_keyword"];
              target_label = "priority";
            }
            {
              source_labels = ["__journal_syslog_message_severity"];
              target_label = "level";
            }
            {
              source_labels = ["__journal_syslog_message_facility"];
              target_label = "facility";
            }
          ];
        }
      ];
    };
  };
}
