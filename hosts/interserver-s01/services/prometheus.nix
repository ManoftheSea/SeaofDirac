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
      {
        job_name = "garage";
        static_configs = [{targets = ["localhost:3903"];}];
      }
    ];
  };
}
