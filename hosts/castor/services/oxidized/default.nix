{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.oxidized;
  conf = {
    model = "fastiron";
    crash = {
      directory = "${logDir}/crashes";
      hostnames = false;
    };
    input = {
      default = "ssh";
      ssh.secure = false;
      utf8_encoded = true;
    };
    output = {
      default = "file";
      file.directory = "${dataDir}/configs";
    };
    source = {
      default = "csv";
      csv = {
        file = "/run/credentials/oxidized.service/router.db";
        delimiter = ":";
        map = {
          name = 0;
          model = 1;
          username = 2;
          password = 3;
        };
        vars_map = {
          enable = 4;
          ssh_kex = 5;
          ssh_host_key = 6;
        };
      };
    };
    models.fastiron.vars.auth_methods = ["keyboard-interactive"];
  };
  configFile = (pkgs.formats.yaml {}).generate "oxidized.conf" conf;
  dataDir = "/var/lib/oxidized";
  logDir = "/var/log/oxidized";
in {
  services.oxidized = {
    inherit configFile;
    enable = false; # do it manually below
  };

  sops.secrets."oxidized/routerDB" = {};
  systemd.tmpfiles.settings."10-oxidized"."${dataDir}/config"."L+".argument = "${configFile}";
  systemd.services.oxidized = {
    description = "Router Config Backup Daemon";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      DevicePolicy = "closed";
      DynamicUser = true;
      #ExecStart = "${lib.getExe cfg.package} --config-file ${cfg.configFile} --home-dir ${dataDir}";
      Environment = "OXIDIZED_HOME=/var/lib/oxidized";
      ExecStart = "${lib.getExe cfg.package} --config-file config --home-dir ${dataDir}";
      LoadCredential = "router.db:${config.sops.secrets."oxidized/routerDB".path}";
      LogsDirectory = "oxidized";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";
      Restart = "always";
      StateDirectory = "oxidized";
      WorkingDirectory = dataDir;
    };
  };
}
