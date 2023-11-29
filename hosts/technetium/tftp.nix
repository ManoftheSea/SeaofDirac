{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [69];
  networking.firewall.allowedUDPPorts = [69];

  systemd = {
    services."tftp-hpa" = {
      serviceConfig.ExecStart = "${pkgs.tftp-hpa}/bin/in.tftpd -c -L -s /var/lib/tftp -u ${config.users.users.tftp.name}";
      wantedBy = ["multi-user.target"];
    };
    tmpfiles.rules = ["d /var/lib/tftp 1755 ${config.users.users.tftp.name} ${config.users.groups.tftp.name} -"];
  };

  users = {
    users.tftp = {
      isSystemUser = true;
      group = config.users.groups.tftp.name;
    };
    groups.tftp = {};
  };
}
