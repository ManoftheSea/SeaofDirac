{
  services.prometheus = {
    enable = true;
    port = 9001;

    exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
      openFirewall = false;
    };

    scrapeConfigs = [
      {
        job_name = "aluminium";
        static_configs = [
          {
            targets = ["localhost:9100"];
          }
        ];
      }
    ];
  };
}
