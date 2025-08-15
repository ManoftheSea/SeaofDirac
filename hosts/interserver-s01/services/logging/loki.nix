{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.loki;
  lokiConfig = {
    auth_enabled = false;
    common = {
      instance_interface_names = ["lo"] ++ (builtins.attrNames config.systemd.network.networks);
      path_prefix = cfg.dataDir;
      replication_factor = 1;
      ring = {
        instance_addr = "::1";
        kvstore.store = "inmemory";
      };
    };
    schema_config.configs = [
      {
        from = "2025-08-15";
        store = "tsdb";
        object_store = "s3";
        schema = "v13";
        index = {
          prefix = "index_";
          period = "24h";
        };
      }
    ];
    server = {
      log_level = "warn";
      http_listen_port = 3100;
    };
    storage_config = {
      aws = {
        endpoint = "localhost:3900";
        insecure = true;
        region = "us-east-1";
        bucketnames = "loki-bucket";
        s3forcepathstyle = true;
        access_key_id = "\${S3_ACCESS_KEY_ID}";
        secret_access_key = "\${S3_ACCESS_KEY_SECRET}";
      };
      tsdb_shipper = {
        active_index_directory = "${cfg.dataDir}/index";
        cache_location = "${cfg.dataDir}/index_cache";
      };
    };
  };
in {
  environment.systemPackages = [cfg.package];

  services.loki = {
    configuration = lokiConfig;
    extraFlags = ["--config.expand-env=true"];
  };

  sops.secrets.loki-env = {};

  systemd.services.loki = {
    description = "Loki Service Daemon";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    serviceConfig = let
      conf = pkgs.runCommand "loki-config.json" {} ''
        echo '${builtins.toJSON cfg.configuration}' | ${pkgs.jq}/bin/jq 'del(._module)' > $out
      '';
    in {
      DevicePolicy = "closed";
      DynamicUser = true;
      EnvironmentFile = config.sops.secrets.loki-env.path;
      ExecStart = "${cfg.package}/bin/loki --config.file=${conf} ${pkgs.lib.escapeShellArgs cfg.extraFlags}";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";
      Restart = "always";
      StateDirectory = "loki";
      User = cfg.user;
      WorkingDirectory = cfg.dataDir;
    };
  };
}
